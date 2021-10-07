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
	hp -= weapon.damage * obj_debug.capture_damage(id)
	state_switch_attack(obj_looter)
	dir = point_direction(x, y, obj_looter.x, obj_looter.y)
	trigger_friendly_units()
	if hp <= 0 {
		instance_destroy()
	}
}

#region ai patrol
function state_switch_idle() {
	state = "idle"
	self.set_sp_to(0, dir)
	target = noone
}

function state_switch_patrol() {
	state = "patrol"
}

function state_switch_attack(trg) {
	if global.ai_attack_off {
		return
	}
	self.set_sp_to(0, dir)
	target = trg
	dir = inst_dir(target)
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

function patrol_set_next_point() {
	patrol_point_to = noone
	var num = array_length(patrol_route)
	var next_planet_index = cycle_increase(patrol_planet_index, 0, num)
	var next_planet = patrol_route[next_planet_index]
	if patrol_try_set_planet(next_planet) {
		patrol_planet_index = next_planet_index
		return true
	}
	patrol_set_next_local_point()
	if patrol_point_to
		return true
	return false
}

function patrol_try_set_planet(planet) {
	var success = false
	var min_dist = infinity
	var planet_points = planet_get_patrol_points(planet)
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
	var planet_points = planet_get_patrol_points(cur_planet)
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

//// behavior
state = "idle"
patrol_planet_index = 0
patrol_point_to = noone
ai_attack_move_sign = 1
// arg: is_patrol = false
// arg: patrol_route = []

is_moving_object = true
sp.normal = 2.5
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.25
decel = 0.2
dir = 0

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
