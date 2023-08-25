
event_inherited()

function set_hit(attacker, weapon) {
	if !global.player_immortal and !global.no_damage
		hp -= weapon.damage
	if hp <= 0 {
		global.game_over = true
		image_index = 1
	}
}

function update_weapon_arr() {
	var wp_names = variable_struct_get_names(global.weapon_types)
	for (var i = 0; i < array_length(wp_names); ++i) {
	    var wname = wp_names[i]
		var weapon = GetWeapon(wname)
		if Resources.get(weapon.resource) >= 1
				and weapon.player_can_use
			array_push(use_weapon_arr, weapon)
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
	if Resources.try_spend(use_weapon.resource, use_weapon.resource_amount)
		use_weapon.shoot(shoot_dir, id)
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
