
event_inherited()


function set_hit(weapon) {
	hp -= weapon.dmg
	if hp <= 0 {
		global.game_over = true
		image_index = 1
	}
}

function add_resource(type, ammount) {
	var cur_load = cargo_load
	var max_load = cargo
	if type == Resource.fuel {
		cur_load = tank_load
		max_load = tank
	}
	if (cur_load + ammount) > max_load
		show_error(" :add_resource: resulting cargo_load greater than cargo", false)
	resources[type] += ammount
	if type == Resource.fuel 
		tank_load += ammount
	else
		cargo_load += ammount
	audio_play_sound(snd_pick, 0, false)
}

function spend_resource(type, ammount) {
	if resources[type] < ammount
		return false
	resources[type] -= ammount
	if type == Resource.fuel
		tank_load -= ammount
	else
		cargo_load -= ammount
	return true
}

function exchange_resources(in, in_ammount, out, out_ammount) {
	// metall 1, ore 3
	// check resource
	if resources[out] < out_ammount
		return "need more\n" + global.resource_names[out]
	// check loads
	var crg = cargo_load
	var tnk = tank_load
	var in_fuel = in == Resource.fuel
	var out_fuel = out == Resource.fuel
	crg += in_ammount * !in_fuel - out_ammount * !out_fuel
	tnk += in_ammount * in_fuel - out_ammount * out_fuel
	if crg > cargo
		return "cargo full"
	if tnk > tank
		return "tank full"
	// exchange
	resources[in] += in_ammount
	resources[out] -= out_ammount
	cargo_load = crg
	tank_load = tnk
	return "ok"
}

function check_cargo_full(ammount) {
	return (cargo_load + ammount) > cargo
}

function upgrade_system(sys) {
	if upgrades_count == core_power
		return "core power\n depleted"
	var cur_level = variable_struct_get(Upgrades, sys)
	var available = variable_struct_get(AvailableUpgrades, sys)
	if cur_level == array_length(available) - 1
		return "  system\nfully upgraded"
	var up_level = cur_level + 1
	var next = available[up_level]
	var costarr = next.cost
	// check resources are enough
	for (var i = 0; i < array_length(costarr); ++i) {
		var restype = costarr[i][0]
		var resammount = costarr[i][1]
		if resources[restype] < resammount
			return "need more\n" + global.resource_names[restype]
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

grav = 0.05
gravx = 0
gravy = 0
gravity_dist = 300
gravity_min_dist = 8

resources = array_create(Resource.types_number, 20)
resources[0] = 0

current_planet = noone

side = Sides.ours

// warping
warping = false
warp_sound = noone

// cruise mode
in_cruise_mode = 0
cruise_switch_sp = 0.01
cruise_dir_to = 0
cruise_acc = 1
cruise_rot_sp = 0.5
cruise_sp = 0

// systems
hp_max = 10
hp = hp_max
cargo = 100
tank = 100
tank_load = resources[Resource.fuel]
cargo_load = array_sum(resources) - resources[Resource.fuel]
core_power = 5
upgrades_count = 0
warp_fuel_cost = 10
AvailableUpgrades = {
	weapon: [
		{cost: [[Resource.part, 10]], value: {dmg: 1.5, mining: 1.15, reload_time: 8, consumption: 0.05, knock_back_force: 4.5}},
		{cost: [[Resource.part, 10]], value: {dmg: 2, mining: 1.3, reload_time: 7.5, consumption: 0.07, knock_back_force: 4.5}},
		{cost: [[Resource.part, 10]], value: {dmg: 2.5, mining: 1.35, reload_time: 7.5, consumption: 0.08, knock_back_force: 4.5}},
		{cost: [[Resource.part, 10]], value: {dmg: 3.5, mining: 1.35, reload_time: 7, consumption: 0.1, knock_back_force: 4.5}},
	],
	cargo: [{cost:[[Resource.part, 10]], value: 130},
			{cost:[[Resource.part, 10]], value: 155},
			{cost:[[Resource.part, 10]], value: 175}, ],
	tank: [{cost:[[Resource.part, 10]], value: 140},
		   {cost:[[Resource.part, 10]], value: 180},
		   {cost:[[Resource.part, 10]], value: 220}, ],
	sp: [{cost:[[Resource.part, 10]], value: {normal: 6, cruise: 12, consumption: 0.005}},
		   {cost:[[Resource.part, 10]], value: {normal: 7, cruise: 15, consumption: 0.005}},
		   {cost:[[Resource.part, 10]], value: {normal: 8, cruise: 17.5, consumption: 0.005}},
		   {cost:[[Resource.part, 10]], value: {normal: 9, cruise: 20, consumption: 0.005}},
		   {cost:[[Resource.part, 10]], value: {normal: 10, cruise: 22.5, consumption: 0.005}}, ],
}
Upgrades = {
	weapon: -1,
	cargo: -1,
	tank: -1,
	sp: -1,
}

// drawing compas
compas_min_dist = 600
compas_r = 100

if not instance_exists(obj_camera) {
	with instance_create_layer(x, y, layer, obj_camera)
		obj_camera.target = other.id
}

