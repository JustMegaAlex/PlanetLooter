
event_inherited()


function set_hit(weapon) {
	if !global.player_immortal or !global.no_damage
		hp -= weapon.damage
	if hp <= 0 {
		global.game_over = true
		image_index = 1
	}
}

function init_resources() {
	var res_names = variable_struct_get_names(global.resource_types)
	for (var i = 0; i < array_length(res_names); ++i) {
	    var name = res_names[i]
		self.resources[$ name] = 0
	}
}

function add_resource(rname, ammount) {
	if self._add_resource(rname, ammount) {
		audio_play_sound(snd_pick, 0, false)
		return true
	}
	return false
}

function _add_resource(rname, ammount) {
	var cur_load = cargo_load
	var max_load = cargo
	if rname == "fuel" {
		cur_load = tank_load
		max_load = tank
	}
	if (cur_load + ammount) > max_load
		return false
	if rname == "fuel"
		tank_load += ammount
	else {
		cargo_load += ammount
		resources[$ rname] += ammount
	}
	// affect weapons
	var rtype = global.resource_types[$ rname]
	if rtype.is_bullet {
		if !array_has(use_weapon_arr, rtype.bullet_name) {
			var wtype = global.weapon_types[$ rtype.bullet_name]
			if resources[$ rname] > wtype.resource_ammount
				array_push(use_weapon_arr, rtype.bullet_name)
		}
	}
	return true
}

function spend_resource(rname, ammount) {
	if rname == "empty"
		return true

	if rname == "fuel" {
		if tank_load < ammount
			return false
		tank_load -= ammount
		fuel_producer_pause = fuel_producer_pause_time
		return true
	}

	if resources[$ rname] < ammount
		return false
	resources[$ rname] -= ammount
	cargo_load -= ammount
	// affect weapons
	var rtype = global.resource_types[$ rname]
	if rtype.is_bullet {
		var wtype = global.weapon_types[$ rtype.bullet_name]
		if resources[$ rname] < wtype.resource_ammount
			use_weapon_remove(rtype.bullet_name)
	}
	return true
}

function exchange_resources(in, in_ammount, cost_info) {
	// metall 1, ore 3
	// check resource
	var in_fuel = (in == "fuel")
	var in_empty = (in == "empty")
	var crg = cargo_load + in_ammount * !in_fuel * !in_empty
	var tnk = tank_load + in_ammount * in_fuel * !in_empty
	var cost_info_names = variable_struct_get_names(cost_info)
	for (var i = 0; i < array_length(cost_info_names); ++i) {
		var _type = cost_info_names[i]
		var _ammount = cost_info[$ _type]
		var result_cost_ammount = _ammount * in_ammount
		if resources[$ _type] < result_cost_ammount
			return "need more\n" + _type
		// check loads
		var out_fuel = (_type == "fuel")
		crg -= result_cost_ammount * !out_fuel
		tnk -= result_cost_ammount * out_fuel
	}
	// check cargo and tank fullness
	if crg > cargo
		return "cargo full"
	if tnk > tank
		return "tank full"
	// exchange
	for (var i = 0; i < array_length(cost_info_names); ++i) {
	    var _type = cost_info_names[i]
		self.spend_resource(_type, cost_info[$ _type] * in_ammount)
	}
	self._add_resource(in, in_ammount * !in_empty)
	cargo_load = crg
	tank_load = tnk
	return "ok"
}

function check_cargo_full(ammount) {
	return (cargo_load + ammount) > cargo
}

function update_use_weapon_arr() {
	var wp_names = variable_struct_get_names(global.weapon_types)
	for (var i = 0; i < array_length(wp_names); ++i) {
	    var wname = wp_names[i]
		var wtype = global.weapon_types[$ wname]
		if resources[$ wtype.resource] >= 1
			array_push(use_weapon_arr, wname)
	}
	// init use_weapon
	if (use_weapon_index == -1) and array_length(use_weapon_arr)
		use_weapon_index = 0
		use_weapon = use_weapon_arr[use_weapon_index]
}

function use_weapon_remove(wtype) {
	array_remove(use_weapon_arr, wtype)
	use_weapon_index = max(use_weapon_index - 1, 0)
	if array_length(use_weapon_arr)
		use_weapon = use_weapon_arr[use_weapon_index]
}

function switch_weapon(swtch) {
	var num = array_length(use_weapon_arr)
	if swtch
		use_weapon_index = cycle_increase(use_weapon_index, 0, num)
	else
		use_weapon_index = cycle_decrease(use_weapon_index, 0, num)
	use_weapon = use_weapon_arr[use_weapon_index]
}

function looter_shoot(shoot_dir) {
	var weapon = global.weapon_types[$ use_weapon]
	if spend_resource(weapon.resource, weapon.resource_ammount)
		shoot(shoot_dir, id, use_weapon)
}

function upgrade_system(sys) {
	if upgrades_count == core_power
		return "core power\n depleted"
	var cur_level = Upgrades[$ sys]
	var available = AvailableUpgrades[$ sys]
	if cur_level == array_length(available) - 1
		return "  system\nfully upgraded"
	var up_level = cur_level + 1
	var next = available[up_level]
	var cost_info = next.cost
	// check resources are enough
	var cost_info_names = variable_struct_get_names(cost_info)
	for (var i = 0; i < array_length(cost_info_names); ++i) {
		var _type = cost_info_names[i]
		if resources[$ _type] < cost_info[$ _type]
			return "need more\n" + restype
	}
	// spend resoures
	for (var i = 0; i < array_length(costarr); ++i) {
		var restype = costarr[i][0]
		var resammount = costarr[i][1]
		spend_resource(restype, resammount)
	}
	var val = available[up_level].value
	upgrades_count++
	variable_struct_set(Upgrades, sys, up_level)
	variable_instance_set(id, sys, val)
	return "ok"
}

function try_repair() {
	if spend_resource("repair_kit", 1)
		hp++
}


position = new Vec2d(x, y)
velocity = new Vec2d(0, 0)
velocity_to = new Vec2d(0, 0)
acceleration = new Vec2d(0.5, 0.5)
deceleration = new Vec2d(0.2, 0.2)
is_moving_object = true
sp = {normal: 5, cruise: 10, consumption: 0.005}
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
dir = 0

image_speed = 0

shoot_dir = 0
reloading = 0
bullet_sp = 14

grav = 0.0
gravx = 0
gravy = 0
gravity_dist = 300
gravity_min_dist = 8

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

// devices
fuel_producer_ratio = 0.001
fuel_producer_pause_time = 120
fuel_producer_pause = 0

// new resource sys
resources = {}
resources_display_names = ["ore", "organic", "junk", "metall", "drives", "part", "bullet_homing", "repair_kit"]
init_resources()

// systems
hull = 10
hp = hull
cargo = 100
tank = 15
tank_load = tank
resources[$ "fuel"] = tank
cargo_load = struct_sum(resources) - resources[$ "fuel"]
core_power = 5
upgrades_count = 0
warp_fuel_cost = 7.5
AvailableUpgrades = {
	weapon: [
		{cost: {part: 10}, value: {dmg: 1.5, mining: 1.15, reload_time: 8, consumption: 0.05, knock_back_force: 3.5}},
		{cost: {part: 15}, value: {dmg: 2, mining: 1.3, reload_time: 7.5, consumption: 0.07, knock_back_force: 3.5}},
		{cost: {part: 25}, value: {dmg: 2.5, mining: 1.35, reload_time: 7.5, consumption: 0.08, knock_back_force: 3.5}},
		{cost: {part: 40}, value: {dmg: 3.5, mining: 1.35, reload_time: 7, consumption: 0.1, knock_back_force: 3.5}},
	],
	cargo: [{cost:{part: 10}, value: 130},
			{cost:{part: 15}, value: 155},
			{cost:{part: 20}, value: 175}, ],
	tank: [{cost:{part: 5}, value: 20},
		   {cost:{part: 12}, value: 30},
		   {cost:{part: 24}, value: 40}, ],
	sp: [{cost:{part: 10}, value: {normal: 6, cruise: 18, consumption: 0.0085}},
		   {cost:{part: 20}, value: {normal: 7, cruise: 21, consumption: 0.009}},
		   {cost:{part: 30}, value: {normal: 8, cruise: 24, consumption: 0.0105}},
		   {cost:{part: 30}, value: {normal: 9, cruise: 27, consumption: 0.012}},
		   {cost:{part: 30}, value: {normal: 10, cruise: 30, consumption: 0.014}}, ],
	hull: [{cost:{part: 5}, value: 13},
			{cost:{part: 12}, value: 16},
			{cost:{part: 20}, value: 20}, ],
}
Upgrades = {
	weapon: -1,
	cargo: -1,
	tank: -1,
	sp: -1,
	hull: -1,
}

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
update_use_weapon_arr()


// create module ui
create_module_ui_inst = noone
