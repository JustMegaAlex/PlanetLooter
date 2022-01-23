// args: ai

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

function get_collectibles_around_me() {
	ds_list_clear(collectibles_around_me)
	if mining_block_pos != undefined {
		collision_circle_list(mining_block_pos.X, mining_block_pos.Y,
							  global.ai_mobs_look_for_collectibles_radius,
							  obj_collectable, false, false, collectibles_around_me, true)
	}
	return collectibles_around_me
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

function state_switch_on_route(route) {
	state = "on_route"
	set_move_route(route)
}

function state_switch_mining() {
	var d = global.grid_size * 0.5
	self.set_sp_to(0, 0)
	target = mining_block
	state = "mining"
}

function state_switch_collect() {
	state = "collect"
}

function ai_return_to_home() {
	ai_travel_to_point(home_base.x, home_base.y)
	on_route_finished_method = ai_start_mining_or_idle
}


function ai_return_to_base_or_idle() {
	if !instance_exists(home_base) {
		state = "idle"
		return false
	}
	state = "on_route"
	move_route = global.astar_graph.find_path(position, get_instance_center(home_base))
	set_move_route(move_route)
}

function ai_travel_to_point(xx, yy) {
	if move_to_set_coords(xx, yy) {
		state = "on_route"
		return true
	}
	return false
}

function ai_start_mining_or_idle() {
	mining_block = find_mining_block()
	target = mining_block
	if mining_block == noone {
		state_switch_idle()
		return true
	}
	// check collision line excluding mining_block
	var xx = mining_block.x
	var yy = mining_block.y
	var line = new Line(x, y, xx, yy)
	var len = line.len()
	line.mult((len + 50)/len)
	inst_set_pos(mining_block, line.xend, line.yend)
	var collision = collision_line(x, y, xx, yy, obj_block, false, false)
	inst_set_pos(mining_block, xx, yy)
	if collision {
		state_switch_on_route(move_route)
		target = noone
		return true
	}
	state_switch_mining()
	return true
}
#endregion


function trigger_friendly_units() {
	/*
	see alarm[1]
	*/
	if global.ai_attack_off { return }

	ds_list_empty(friendly_units_to_trigger)
	collision_circle_list(x, y, trigger_radius_on_detection,
						  obj_enemy, false, true,
						  friendly_units_to_trigger, false)
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
						obj_planet_mask, 16)
}

function patrol_update_route() {
	patrol_point_to = patrol_get_next_point()
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

function patrol_set_next_point() {
	patrol_point_to = noone
	var _prev_index = patrol_point_index
	var next_planet = patrol_get_next_point()
	if patrol_try_set_point(next_planet)
		return true
	patrol_point_index = _prev_index
	patrol_set_next_local_point()
	if patrol_point_to
		return true
	return false
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

function find_mining_block() {
	it = new IterInstances(obj_planet)
	var block = noone
	var block_extra_dist = global.ai_rebel_block_extra_dist
	while it.next() != undefined {
		var planet = it.get()
		block = get_resource_block_most_close_to_surface(planet)
		if block == noone
			continue
		var block_depth_i = block.i
		var block_depth_j = block.j
		var i_side = -1
		var j_side = -1
		if block.i > (planet.size - block.i) {
			i_side = 1
			block_depth_i = planet.size - block.i
		}
		if block.j > (planet.size - block.j) {
			j_side = 1
			block_depth_j = planet.size - block.j
		}
		
		var nearest_point_to_block = new Vec2d(block.x + (block_depth_i + 2 + block_extra_dist) * i_side * global.grid_size, block.y)
		if block_depth_i > block_depth_j {
			var nearest_point_to_block = new Vec2d(block.x, block.y + (block_depth_j + 2 + block_extra_dist) * j_side * global.grid_size)
		}
		
		harvest_point = nearest_point_to_block
		
		move_route = global.astar_graph.find_path(position, nearest_point_to_block)
		// fail
		if move_route == global.AstarPathFindFailed {
			self.astar_failed()
			return noone
		}
		set_move_route(move_route)
	}
	if block != noone {
		block.visible = true
		mining_block_pos = new Vec2d(block.x, block.y)
	}
	return block
}

//// behavior
state = "idle"
on_route_finished_method = undefined
move_route = []
move_route_point_to = undefined
iter_move_route = new IterArray([])
ai_attack_move_sign = 1

find_path_failed_point = noone
colliding_with = noone

mining_block = noone
mining_block_pos = undefined
harvest_point = undefined
home_base = noone
collect_wait_on_collision = 30

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
trigger_radius_on_detection = 100
trigger_units_delay = 5
friendly_units_to_trigger = ds_list_create()
dir_wiggle = 0
dir_wiggle_magnitude = 40
dir_wiggle_change_time = 30
dir_wiggle_delay = 0
loose_dist = 700
attack_min_dist = 200
attack_max_dist = 300
target = noone
search_time = 300
searching = 0
xst = x
yst = y
start_area_radius = 100

shoot_dir = 0
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

hp = 7

side = Sides.theirs
use_weapon = "pulse"
cargo = 20
Resources.init()
assign_creation_arguments()
make_late_init()
