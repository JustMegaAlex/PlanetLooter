// args: ai
is_patrol = false
patrol_route = []

event_inherited()

function set_hit(attacker, weapon) {
	if !global.no_damage
		hp -= weapon.damage
    var trigger_friends = array_find(["attack", "attack_snipe"], state) == -1
	state_switch_attack(obj_looter, trigger_friends)
	set_dir_to(point_direction(x, y, obj_looter.x, obj_looter.y))
	trigger_friendly_units()
	if hp <= 0 {
		instance_destroy()
	}
}

#region ai states
function state_switch_idle() {
	state = "idle"
	self.set_sp_to(0, dir)
	target = noone
}

function state_switch_attack_snipe(trg) {
	if global.ai_attack_off {
		return
	}
    self.state_switch_attack(trg)
    self.use_weapon = "pulse_snipe"
    state = "attack_snipe"
}

function state_switch_attack(trg, trigger_friends=false) {
	if global.ai_attack_off
			or state == "attack"
			or state == "attack_snipe" {
		return
	}
    self.use_weapon = "pulse_spread"
	self.set_sp_to(0, dir)
	target = trg
	set_dir_to(inst_dir(target))
	if warmedup < 1
		state = "warmup"
	else
		state = "attack"
	if trigger_friends
		trigger_friendly_units()
}

function state_switch_search() {
	state = "search"
	searching = search_time
}

function state_switch_return() {
	state = "return"
}

function state_switch_on_route(xx, yy) {
	if move_to_set_coords(xx, yy) {
		state = "on_route"
		return true
	}
	return false
}
#endregion

//function attack_create_units_formation(list_units) {
//	var snipers_num = ds_list_size(list_units) * 
//}

function trigger_friendly_units() {
	/*
	see alarm[1]
	*/
	if global.ai_attack_off { return }

	ds_list_empty(friendly_units_to_trigger)
	collision_circle_list(x, y, trigger_radius_on_detection,
						  obj_enemy, false, true,
						  friendly_units_to_trigger, false)
	trigger_attack_snipers_num = floor(ds_list_size(friendly_units_to_trigger)
									   * attack_formation_snipers_fract)
	alarm[1] = trigger_units_delay
}

function compute_strafe_vec() {
	for (var i = 0; i < instance_number(obj_enemy); ++i) {
		var inst = instance_find(obj_enemy, i)
	    var dist = max(inst_dist(inst), 1)
		if (dist > battle_friendly_dist) or (inst == id)
			continue
		var friend_dir = inst_dir(inst)
		battle_strafe_vec.add_polar(-1 / dist, friend_dir)
	}
	battle_strafe_vec.normalize()
	// manuver if enough space
}

function set_move_route(route) {
	iter_move_route = new IterArray(route)
}

function path_blocked(xx, yy) {
	return collision_line_width(x, y, xx, yy,
						obj_planet_mask, 12)
}

function update_route() {
	move_route_point_to = iter_move_route.next()
	return move_route_point_to
}

function patrol_get_next_point() {
	var num = array_length(patrol_route)
	patrol_point_index = cycle_increase(patrol_point_index, 0, num)
	var next_point = patrol_route[patrol_point_index]
	return next_point
}

function patrol_set_next_point() {
	patrol_point_to = noone
	var _prev_index = patrol_point_index
	var next_point = patrol_get_next_point()
	if patrol_try_set_point(next_point)
		return true
	patrol_point_index = _prev_index
	patrol_set_next_local_point()
	if patrol_point_to
		return true
	return false
}

function patrol_try_set_point(p) {
	if not collision_line(x, y, p.X, p.Y, obj_block, false, true) {
		return true
	}
	return false
}

function patrol_set_next_local_point() {
	var min_dist = infinity
	var cur_planet = patrol_route[patrol_point_index]
	var planet_points = planet_get_route_points(cur_planet)
	for (var i = 0; i < array_length(planet_points); i++) {
		var p = planet_points[i]
		if not collision_line(x, y, p.X, p.Y, obj_block, false, true) {
			var cur_dist = point_dist(p.X, p.Y)
			if min_dist > cur_dist {
				min_dist = cur_dist
				patrol_point_to = p
			}
		}
	}
}

function set_start_point(xx, yy) {
	xst = xx
	yst = yy
}

function astar_failed() {
	state = ""
	set_sp_to(0, 0)
	find_path_failed_point = patrol_point_to
	show_debug_message(
		"ERROR: find path failed\n"
		+ "   seed: " + string(obj_level_gen.level_seed) + "\n"
		+ "   pstart: " + string({X:position.X, Y: position.Y})
		+ "   pfinish: " + string({X:find_path_failed_point.X, Y: find_path_failed_point.Y})
	)
}

//// behavior
state = "idle"
patrol_point_index = 0
patrol_point_to = noone
move_route = []
move_route_point_to = noone
prev_dist_to_route_point = -1
iter_move_route = new IterArray([])
ai_attack_move_sign = 1

find_path_failed_point = noone


// arg: is_patrol = false
// arg: patrol_route = []

is_moving_object = true
is_collecting_things = false
sp.normal = 2.5
position = new Vec2d(x, y)
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.25
decel = 0.2
dir = 0
dir_to = 0
rotation_sp = 5

detection_dist = 300
trigger_radius_on_detection = 200
trigger_units_delay = 5
friendly_units_to_trigger = ds_list_create()
dir_wiggle = 0
dir_wiggle_magnitude = 40
dir_wiggle_change_time = 30
dir_wiggle_delay = 0
loose_dist = 700
attack_min_dist = 200
attack_max_dist = 300
attack_snipe_min_dist = 350
attack_snipe_max_dist = 500
attack_formation_snipers_fract = global.enemy_attack_formation_snipers_fract
detection_dist_search = 400
target = noone
search_time = 300
searching = 0
xst = x
yst = y
start_area_radius = 100

shoot_dir = 0
shoot_dir_wiggle = 8
reloading = 0
weapon.reload_time = 25
bullet_sp = 10
warmedup = 0
warmup_sp = 0.01

// keeping distance with friends
battle_friendly_dist = 100
battle_strafe_vec = new Vec2d(0, 0)
battle_strafe_vec_treshold = sp.normal * 0.1
battle_strafe_dirsign = choose(-1, 1)

// controlled building
controlled_building = noone

hp = 7

side = Sides.theirs
use_weapon = "pulse_spread"

// alert tower
alert_tower_inst = noone

assign_creation_arguments()

if is_patrol
	patrol_update_route()
