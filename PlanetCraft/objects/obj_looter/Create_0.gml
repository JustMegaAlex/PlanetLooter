
event_inherited()


function set_hit(weapon) {
	hp -= weapon.dmg
	if hp <=0 {
		global.game_over = true
		image_index = 1
	}
}

function add_resource(type, ammount) {
	if cargo_load >= cargo
		show_error(" :add_resource: cargo_load > cargo", false)
	resources[type] += ammount
	audio_play_sound(snd_pick, 0, false)
}


function check_cargo_full(type) {
	return cargo_load >= cargo
}

//// production
function ore_to_metall() {
	if resources[Resource.ore] >= ore_to_metall_cost {
		resources[Resource.metall] += 1
		resources[Resource.ore] -= ore_to_metall_cost
		return "ok"
	}
	return "need more\n   ore"
}

function organic_to_fuel() {
	if resources[Resource.organic] >= organic_to_fuel_cost {
		resources[Resource.fuel] += 1
		resources[Resource.organic] -= organic_to_fuel_cost
		return "ok"
	}
	return "need more\norganic"
}

function produce_part() {
	if resources[Resource.metall] >= metall_to_part_cost {
		resources[Resource.part] += 1
		resources[Resource.metall] -= metall_to_part_cost
		return "ok"
	}
	return "need more\nmetall"
}

function upgrade_weapon() {
	if resources[Resource.part] >= weapon_upgr_part_cost {
		dmg += 1
		resources[Resource.part] -= weapon_upgr_part_cost
		return "ok"
	}
	return "need more\nparts"
}

function upgrade_repair() {
	if resources[Resource.metall] >= repair_cost {
		hp += 1
		resources[Resource.metall] -= repair_cost
		return "ok"
	}
	return "need more\nmetal"
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
			return "need more\n" + global.resource_names[type]
	}
	// spend resoures
	for (var i = 0; i < array_length(costarr); ++i) {
		var restype = costarr[i][0]
		var resammount = costarr[i][1]
		resources[restype] -= resammount
	}
	var val = available[up_level].value
	upgrades_count++
	variable_struct_set(Upgrades, sys, up_level)
	variable_instance_set(id, sys, val)
	return "ok"
}

//// production
ore_to_metall_cost = 3
organic_to_fuel_cost = 2
metall_to_part_cost = 2
weapon_upgr_part_cost = 5
speed_upgr_cost = 2
repair_cost = 1

is_moving_object = true
sp = 5
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

resources = array_create(Resource.types_number, 10)

current_planet = noone

side = Sides.ours

// warping
warping = false
warp_sound = noone

// systems
hp_max = 8
hp = hp_max
cargo = 100
cargo_load = array_sum(resources)
tank = 100
core_power = 5
upgrades_count = 0
AvailableUpgrades = {
	weapon: [
		{cost: [[Resource.part, 10]], value: {dmg: 1.5, mining: 1.15, reload_time: 8, consumption: 0.2, knock_back_force: 4.5}},
		{cost: [[Resource.part, 10]], value: {dmg: 2, mining: 1.3, reload_time: 7.5, consumption: 0.3, knock_back_force: 4.5}},
		{cost: [[Resource.part, 10]], value: {dmg: 2.5, mining: 1.35, reload_time: 7.5, consumption: 0.4, knock_back_force: 4.5}},
		{cost: [[Resource.part, 10]], value: {dmg: 3.5, mining: 1.35, reload_time: 7, consumption: 0.5, knock_back_force: 4.5}},
	],
	cargo: [{cost:[[Resource.part, 10]], value: 130},
			{cost:[[Resource.part, 10]], value: 155},
			{cost:[[Resource.part, 10]], value: 175}, ],
	tank: [{cost:[[Resource.part, 10]], value: 140},
		   {cost:[[Resource.part, 10]], value: 180},
		   {cost:[[Resource.part, 10]], value: 220}, ],
	sp: [{cost:[[Resource.part, 10]], value: 6},
		   {cost:[[Resource.part, 10]], value: 7},
		   {cost:[[Resource.part, 10]], value: 8},
		   {cost:[[Resource.part, 10]], value: 9},
		   {cost:[[Resource.part, 10]], value: 10}, ],
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
		obj_camera.target = id
}

