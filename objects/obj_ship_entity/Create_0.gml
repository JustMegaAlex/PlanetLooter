
event_inherited()

function get_collectibles_around_me() {
	ds_list_clear(collectibles_around_me)
	collision_circle_list(x, y, global.ai_mobs_look_for_collectibles_radius,
						  obj_collectable, false, false, collectibles_around_me, true)
	return collectibles_around_me
}

function set_sp_to(sp, dir) {
	hsp_to = lengthdir_x(sp, dir)
	vsp_to = lengthdir_y(sp, dir)
}

function set_dir_to(_dir_to) {
	dir_to = _dir_to
}

function update_dir(rot_sp=rotary_sp) {
	var diff = angle_difference(dir_to, dir)
	if abs(diff) < rot_sp {
		dir = dir_to
		return true
	}
	var sign_ = sign(diff)
	dir += rotary_sp * sign_
}

function get_abs_sp() {
	return point_distance(0, 0, hsp, vsp)
}

#region ai

function move_to_set_coords(xx, yy) {
	if !path_blocked(xx, yy)
		return true
	var route = astar_find_path(position, new Vec2d(xx, yy))
	if route == global.AstarPathFindFailed
		return false
	set_move_route(route)
	return true
}

function ai_travel_to_point(xx, yy) {
	if move_to_set_coords(xx, yy) {
		state = "on_route"
		return true
	}
	return false
}
#endregion

#region resources

Resources = {
	id: id,
	init: function() {
		var res_names = variable_struct_get_names(global.resource_types)
		for (var i = 0; i < array_length(res_names); ++i) {
		    var name = res_names[i]
			if name == "fuel"
				continue
			self[$ name] = global.start_resources_amount
		}
	},

	get: function(name) {
		if name == "fuel"
			return id.tank
		return self[$ name]
	},
	
	get_sum: function() {
		var it = new IterStruct(global.resource_types)
		var sum = 0
		while it.next() {
			var name = it.key()
			if (name != "fuel")
				sum += self[$ name]
		}
		return sum
	},
	
	has_enough: function(name, amount) {
		if name == "fuel"
			return id.tank_load >= amount
		return self[$ name] >= amount
	},
	
	has_enough_of_cost: function(cost) {
		var it = new IterStruct(cost)
		while it.next() {
			if !self.has_enough(it.key(), it.value())
				return "not enough " + it.key()
		}
		return "ok"
	},
	
	check_availability: function(info, in_amount, crg, tnk) {
		var iter = new IterStruct(info)
		while iter.next() {
			var _type = iter.key()
			var _amount = iter.value()
			var result_cost_amount = _amount * in_amount
			if self[$ _type] < result_cost_amount
				return {success: false, msg: "need more\n" + _type}
			// check loads
			var out_fuel = (_type == "fuel")
			crg -= result_cost_amount * !out_fuel
			tnk -= result_cost_amount * out_fuel
		}
		return {crg: crg, tnk: tnk, success: true}
	},
	
	check_overload: function(name, amount) {
		if name == "fuel"
			return (id.tank_load + amount) > id.tank
		return (id.cargo_load + amount) > id.cargo
	},
	
	exchange: function(in, in_amount, cost_info) {
		var in_fuel = (in == "fuel")
		var in_empty = (in == "empty")
		var crg = id.cargo_load + in_amount * !in_fuel * !in_empty
		var tnk = id.tank_load + in_amount * in_fuel * !in_empty
		var checked = check_availability(cost_info, in_amount, crg, tnk)
		if !checked.success
			return checked.msg
		// check cargo and tank fullness
		if checked.crg > id.cargo
			return "cargo full"
		if checked.tnk > id.tank
			return "tank full"
		// exchange
		_spend_via_info(cost_info, in_amount)
		_add(in, in_amount * !in_empty)
		id.cargo_load = checked.crg
		id.tank_load = checked.tnk
		return "ok"
	},

	try_add: function(name, amount) {
		if check_overload(name, amount)
			return false
		_add(name, amount)
		return true
	},

	try_spend: function(name, amount) {
		if !has_enough(name, amount)
			return false
		_spend(name, amount)
		return true
	},

	update_resource_weapon: function(res_name, amount) {
		var rtype = global.resource_types[$ res_name]
		if rtype.is_bullet {
			var wtype = global.weapon_types[$ rtype.bullet_name]
			if amount >= wtype.resource_amount
					and !array_has(id.use_weapon_arr, rtype.bullet_name) {				
				array_push(id.use_weapon_arr, rtype.bullet_name)
			} else if amount < wtype.resource_amount
					and array_has(id.use_weapon_arr, rtype.bullet_name) {
				array_remove(id.use_weapon_arr, rtype.bullet_name)
			}
		}
	},
	
	_spend: function(name, amount) {
		var final
		if name == "fuel" {
			id.tank_load -= amount
			final = id.tank_load
		} else {
			self[$ name] -= amount
			id.cargo_load -= amount
			final = self[$ name]
		}
		update_resource_weapon(name, final)
		return true
	},
	
	_add: function(name, amount) {
		var final
		if name == "fuel" {
			id.tank_load += amount
			final = id.tank_load
		} else {
			self[$ name] += amount
			id.cargo_load += amount
			final = self[$ name]
		}
		update_resource_weapon(name, final)
		return true
	},

	_spend_via_info: function(info, multiplier) {
		var iter = new IterStruct(info)
		while iter.next() {
			var _type = iter.key()
			_spend(_type, info[$ _type] * multiplier)
		}
	},
}

function spend_resource(name, amount) {
	return Resources.try_spend(name, amount)
}

function add_resource(name, amount) {
	return Resources.try_add(name, amount)
}

function check_cargo_full(amount) {
	return (cargo_load + amount) > cargo
}

function try_repair() {
	if Resources.try_spend("repair_kit", 1)
		hp++
}
#endregion

make_late_init()

// systems
hp = 7
weapon = {
	dmg: 1,
	mining: 1,
	reload_time: 10,
	consumption: 0.0,
	knock_back_force: 3.5
}

sp = {normal: 5, cruise: 15, consumption: 0.007}

position = new Vec2d(x, y)
velocity = new Vec2d(0, 0)
velocity_to = new Vec2d(0, 0)
acceleration = new Vec2d(0.5, 0.5)
deceleration = new Vec2d(0.2, 0.2)
is_moving_object = true
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.5
decel = 0.2
hacc = 0
vacc = 0
input_h = 0
input_v = 0
move_h = 0
move_v = 0
input_dir = 0
rotary_sp = 5
dir = 0
dir_to = 0

is_collecting_things = true
collectibles_around_me = ds_list_create()
current_collectible = noone

cargo = global.start_cargo_space
tank = 0
tank_load = tank
cargo_load = 0

// ai
move_route = []
