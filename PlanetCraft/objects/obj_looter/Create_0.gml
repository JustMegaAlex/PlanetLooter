
event_inherited()


function set_hit(weapon) {
	hp -= weapon.dmg * obj_debug.capture_damage(id)
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
		return false
	resources[type] += ammount
	if type == Resource.fuel 
		tank_load += ammount
	else
		cargo_load += ammount
	audio_play_sound(snd_pick, 0, false)
	return true
}

function spend_resource(type, ammount) {
	if resources[type] < ammount
		return false
	resources[type] -= ammount
	if type == Resource.fuel {
		tank_load -= ammount
		fuel_producer_pause = fuel_producer_pause_time
	}
	else
		cargo_load -= ammount
	return true
}

function exchange_resources(in, in_ammount, cost_info_arr) {
	// metall 1, ore 3
	// check resource
	var in_fuel = (in == Resource.fuel)
	var crg = cargo_load + in_ammount * !in_fuel
	var tnk = tank_load + in_ammount * in_fuel
	for (var i = 0; i < array_length(cost_info_arr); ++i) {
	    var cost = cost_info_arr[i]
		var result_cost_ammount = cost.ammount * in_ammount
		if resources[cost.type] < result_cost_ammount
			return "need more\n" + global.resource_names[cost.type]
		// check loads
		var out_fuel = (cost.type == Resource.fuel)
		crg -= result_cost_ammount * !out_fuel
		tnk -= result_cost_ammount * out_fuel
		if crg > cargo
			return "cargo full"
		if tnk > tank
			return "tank full"
	}	
	// exchange
	resources[in] += in_ammount
	for (var i = 0; i < array_length(cost_info_arr); ++i) {
	    var cost = cost_info_arr[i]
		resources[cost.type] -= cost.ammount * in_ammount
	}
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
cruise_switch_sp = 0.02
cruise_dir_to = 0
cruise_acc = 1
cruise_rot_sp = 0.5
cruise_sp = 0

// devices
fuel_producer_ratio = 0.001
fuel_producer_pause_time = 120
fuel_producer_pause = 0

// systems
hull = 10
hp = hull
cargo = 100
tank = 15
tank_load = tank
resources[Resource.fuel] = tank
cargo_load = array_sum(resources) - resources[Resource.fuel]
core_power = 5
upgrades_count = 0
warp_fuel_cost = 10
AvailableUpgrades = {
	weapon: [
		{cost: [[Resource.part, 10]], value: {dmg: 1.5, mining: 1.15, reload_time: 8, consumption: 0.05, knock_back_force: 3.5}},
		{cost: [[Resource.part, 15]], value: {dmg: 2, mining: 1.3, reload_time: 7.5, consumption: 0.07, knock_back_force: 3.5}},
		{cost: [[Resource.part, 25]], value: {dmg: 2.5, mining: 1.35, reload_time: 7.5, consumption: 0.08, knock_back_force: 3.5}},
		{cost: [[Resource.part, 40]], value: {dmg: 3.5, mining: 1.35, reload_time: 7, consumption: 0.1, knock_back_force: 3.5}},
	],
	cargo: [{cost:[[Resource.part, 10]], value: 130},
			{cost:[[Resource.part, 15]], value: 155},
			{cost:[[Resource.part, 20]], value: 175}, ],
	tank: [{cost:[[Resource.part, 5]], value: 20},
		   {cost:[[Resource.part, 12]], value: 30},
		   {cost:[[Resource.part, 24]], value: 40}, ],
	sp: [{cost:[[Resource.part, 10]], value: {normal: 6, cruise: 18, consumption: 0.0085}},
		   {cost:[[Resource.part, 20]], value: {normal: 7, cruise: 21, consumption: 0.009}},
		   {cost:[[Resource.part, 30]], value: {normal: 8, cruise: 24, consumption: 0.0105}},
		   {cost:[[Resource.part, 30]], value: {normal: 9, cruise: 27, consumption: 0.012}},
		   {cost:[[Resource.part, 30]], value: {normal: 10, cruise: 30, consumption: 0.014}}, ],
	hull: [{cost:[[Resource.part, 5]], value: 13},
			{cost:[[Resource.part, 12]], value: 16},
			{cost:[[Resource.part, 20]], value: 20}, ],
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

