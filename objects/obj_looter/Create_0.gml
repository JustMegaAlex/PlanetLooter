
event_inherited()

function set_hit(attacker, weapon) {
	if !global.player_immortal and !global.no_damage
		hp -= weapon.damage
	if hp <= 0 {
		global.game_over = true
		image_index = 1
	}
}

Resources = {
	id: obj_looter,
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

function update_weapon_arr() {
	var wp_names = variable_struct_get_names(global.weapon_types)
	for (var i = 0; i < array_length(wp_names); ++i) {
	    var wname = wp_names[i]
		var wtype = global.weapon_types[$ wname]
		if Resources.get(wtype.resource) >= 1
				and wtype.player_can_use
			array_push(use_weapon_arr, wname)
	}
	// init use_weapon
	if (use_weapon_index == -1) and array_length(use_weapon_arr) {
		use_weapon_index = 0
		use_weapon = use_weapon_arr[use_weapon_index]
	}
}

function use_weapon_remove(wtype) {
	array_remove(use_weapon_arr, wtype)
	use_weapon_index = max(use_weapon_index - 1, 0)
	if array_length(use_weapon_arr)
		use_weapon = use_weapon_arr[use_weapon_index]
}

function switch_weapon(swtch) {
	var num = array_length(use_weapon_arr)
	if num == 0
		return false
	if swtch
		use_weapon_index = cycle_increase(use_weapon_index, 0, num)
	else
		use_weapon_index = cycle_decrease(use_weapon_index, 0, num)
	use_weapon = use_weapon_arr[use_weapon_index]
}

function looter_shoot(shoot_dir) {
	var weapon = global.weapon_types[$ use_weapon]
	if Resources.try_spend(weapon.resource, weapon.resource_amount)
		shoot(shoot_dir, id, use_weapon)
}

function try_repair() {
	if Resources.try_spend("repair_kit", 1)
		hp++
}

sp = {normal: 5, cruise: 10, consumption: 0.005}

image_speed = 0

reloading = 0
bullet_sp = 14

current_planet = noone

side = Sides.ours

// warping
warping = false
warp_sound = noone

// cruise mode
in_cruise_mode = 0
cruise_switch_sp = 0.02
cruise_dir_to = 0
cruise_acc = 1
cruise_rot_sp = 0.5
cruise_sp = 0

// full thrust mode
full_thrust_sp_max = 8
full_thrust_sp = 0
full_thrust_acc = 0.35
full_thrust_rotary_sp = 2
full_thrust_consumption = 0.005

// devices
fuel_producer_ratio = 0.001
fuel_producer_pause_time = 120
fuel_producer_pause = 0
fuel_producer_treshold = 1

// new resource sys
resources_display_names = ["ore", "organic",
						   "junk", "metall",
						   "drives", "part",
						   "bullet_homing",
						   "repair_kit"]
Resources.init()

// systems
hull = 10
hp = hull
cargo = global.start_cargo_space
tank = 15
tank_load = tank
cargo_load = Resources.get_sum()
core_power = 5
warp_fuel_cost = 7.5

// drawing compas
compas_min_dist = 600
compas_r = 100

if not instance_exists(obj_camera) {
	with instance_create_layer(x, y, layer, obj_camera)
		obj_camera.target = other.id
}

// weapon system
use_weapon_arr = []
use_weapon_index = -1
use_weapon = noone
update_weapon_arr()


// create module ui
create_module_ui_inst = noone

// ui interacting
current_ui_source = noone
