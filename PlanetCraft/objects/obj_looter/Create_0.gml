
event_inherited()

function add_resource(type, ammount) {
	if (resources[type] + ammount) > resource_max_ammount
		show_error(" :add_resource: resource type ammount > max ammount", false)
	resources[type] += ammount
}

function check_resource_full(type) {
	return resources[type] >= resource_max_ammount
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
	return "need more\nmetall"
}

//// production
ore_to_metall_cost = 3
organic_to_fuel_cost = 2
metall_to_part_cost = 2
weapon_upgr_part_cost = 5


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

shoot_h = 0
shoot_v = 0
shoot_dir = 0
reload_time = 5
reloading = 0

grav = 0.05
gravx = 0
gravy = 0
gravity_dist = 300
gravity_min_dist = 8

resources = array_create(Resource.types_number, 10)
resource_max_ammount = 10

current_planet = noone

side = Sides.ours

hp = 7
dmg = 1