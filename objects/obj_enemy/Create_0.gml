// args: ai
is_patrol = false
patrol_route = []

event_inherited()

enum Enemy {
	idle,
	wander,
	enclose,
	distantiate,
	search,
}

function set_hit(weapon) {
	if !global.no_damage
		hp -= weapon.damage
	state_switch_attack(obj_looter)
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

function state_switch_patrol() {
	state = "patrol"
    var p = patrol_point_to
	state_switch_on_route(p.X, p.Y)
}

function state_switch_attack(trg) {
	if global.ai_attack_off {
		return
	}
	self.set_sp_to(0, dir)
	target = trg
	set_dir_to(inst_dir(target))
	if warmedup < 1
		state = "warmup"
	else
		state = "attack"
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

function trigger_friendly_units() {
	if global.ai_attack_off { return }

	ds_list_empty(friendly_units_to_trigger)
	collision_circle_list(x, y, trigger_radius_on_detection, obj_enemy, false, true, friendly_units_to_trigger, false)
	alarm[1] = trigger_units_delay
}

function compute_strafe_vec() {
	for (var i = 0; i < instance_number(obj_enemy); ++i) {
		var inst = instance_find(obj_enemy, i)
	    var dist = max(inst_dist(inst), 1)
		if (dist > battle_friendly_dist) or (inst == id)
			continue
		var dir = inst_dir(inst)
		battle_strafe_vec.add_polar(-1 / dist, dir)
	}
	battle_strafe_vec.normalize()
}

function set_move_route(route) {
	iter_move_route = new IterArray(route)
}

function path_blocked(xx, yy) {
	return collision_line_width(x, y, xx, yy,
						obj_planet_mask, 12)
}

function patrol_update_route() {
	var next_planet = patrol_get_next_planet()
	var points = planet_get_route_points(next_planet)
	patrol_point_to = array_choose(points)
	if !path_blocked(patrol_point_to.X, patrol_point_to.Y) {
		set_move_route([patrol_point_to])
		return true
	}
	move_route = global.astar_graph.find_path(position, patrol_point_to)
	// fail
	if move_route == global.AstarPathFindFailed {
		self.astar_failed()
		return false
	}
	set_move_route(move_route)
}

function update_route() {
	move_route_point_to = iter_move_route.next()
	return move_route_point_to
}

function patrol_update_move_to() {
	update_route()
	if move_route_point_to != undefined
		return true
	patrol_update_route()
	update_route()
	return true
}

function patrol_get_next_planet() {
	var num = array_length(patrol_route)
	patrol_planet_index = cycle_increase(patrol_planet_index, 0, num)
	var next_planet = patrol_route[patrol_planet_index]
	return next_planet
}

function patrol_set_next_point() {
	patrol_point_to = noone
	var _prev_index = patrol_planet_index
	var next_planet = patrol_get_next_planet()
	if patrol_try_set_planet(next_planet)
		return true
	patrol_planet_index = _prev_index
	patrol_set_next_local_point()
	if patrol_point_to
		return true
	return false
}

function patrol_try_set_planet(planet) {
	var success = false
	var min_dist = infinity
	var planet_points = planet_get_route_points(planet)
	for (var i = 0; i < array_length(planet_points); i++) {
		var p = planet_points[i]
		if not collision_line(x, y, p.X, p.Y, obj_block, false, true) {
			var cur_dist = point_dist(p.X, p.Y)
			if min_dist > cur_dist {
				min_dist = cur_dist
				patrol_point_to = p
				success = true
			}
		}
	}
	return success
}

function patrol_set_next_local_point() {
	var min_dist = infinity
	var cur_planet = patrol_route[patrol_planet_index]
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

function move_to_set_coords(xx, yy) {
	if !path_blocked(xx, yy)
		return true
	var route = global.astar_graph.find_path(position, new Vec2d(xx, yy))
	if move_route == global.AstarPathFindFailed
		return false
	set_move_route(route)
	return true
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
patrol_planet_index = 0
patrol_point_to = noone
move_route = []
move_route_point_to = noone
iter_move_route = new IterArray([])
ai_attack_move_sign = 1

find_path_failed_point = noone


// arg: is_patrol = false
// arg: patrol_route = []

is_moving_object = true
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
loose_dist = 500
close_dist = 200
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

// controlled building
controlled_building = noone

hp = 7

side = Sides.theirs
use_weapon = "pulse_spread"

// alert tower
alert_tower_inst = noone

assign_creation_arguments()

if is_patrol
	patrol_set_next_point()
