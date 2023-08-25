
function shoot(shoot_dir, spawner, wtype, xx=x, yy=y) {
	var weapon = global.weapon_types[$ wtype]
	if object_is_ancestor(spawner.object_index, obj_ship_entity)
		spawner.reloading = weapon.reload_time

	var object_bullet = obj_bullet
	if variable_struct_exists(weapon, "object")
		object_bullet = weapon.object

	var inst = instance_create_layer(xx, yy, layer, object_bullet)
	inst.image_angle = shoot_dir
	inst.sprite_index = weapon.sprite
	inst.spawner = spawner
	inst.side = spawner.side
	inst.weapon = weapon
	inst.sp = weapon.sp
	inst.type = wtype
	inst.life_distance = weapon.distance
	if object_bullet == obj_bullet_two_phase {
		inst.ph1_distance = weapon.ph1_distance
	}
	var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
	//audio_play_sound(snd, 0, false)
}

function init_resource_bullet_names() {
	var weapon_names = variable_struct_get_names(global.weapon_types)
	for (var i = 0; i < array_length(weapon_names); ++i) {
	    var wname = weapon_names[i]
		var wpn = GetWeapon(wname)
		var resource_name = wpn.resource
		if resource_name != "empty" {
			var rtype = global.resource_types[$ resource_name]
			rtype.is_bullet = true
			rtype.bullet_name = wname
		}
	}
}

function WeaponBase() constructor {
	damage = 1
	mining = 1
	reload_time = 20
	sp = 14
	resource = "empty"												 
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 700
	resource_amount = 1
	player_can_use = false
	object = obj_bullet_two_phase
	ph2_sp = 7
	ph2_img = 1
	ph1_distance = 120
	object_bullet = obj_bullet

	shoot = function(shoot_dir, spawner) {
		if object_is_ancestor(spawner.object_index, obj_ship_entity)
			spawner.reloading = reload_time

		var inst = instance_create_layer(xx, yy, "Instances", object_bullet)
		inst.image_angle = shoot_dir
		inst.sprite_index = sprite
		inst.spawner = spawner
		inst.side = spawner.side
		inst.weapon = self
		inst.sp = sp
		inst.life_distance = distance
		if object_bullet == obj_bullet_two_phase {
			inst.ph1_distance = ph1_distance
		}
		var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
		//audio_play_sound(snd, 0, false)
	}
}

function WeaponPulse() : WeaponBase() constructor {
	damage = 1
	mining = 1
	reload_time = 20
	sp = 14
	resource = "empty"												 
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 700
	resource_amount = 1
	player_can_use = false
	object = obj_bullet_two_phase
	ph2_sp = 7
	ph2_img = 1
	ph1_distance = 120
}

function WeaponTurretPulse() : WeaponBase() constructor {
	damage = 2
	mining = 1
	reload_time = 20
	sp = 20
	resource = "empty"
	knock_back_force = 2
	sprite = spr_common_pulse
	distance = 500
	resource_amount = 1
	player_can_use = false
}

function WeaponPulseSpread() : WeaponBase() constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 7
	resource = "empty"
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 0
	object = obj_bullet_pulse_spread
	resource_amount = 1
	player_can_use = false
}

function WeaponPulseSnipe() : WeaponBase() constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 22
	resource = "empty"
	knock_back_force = 2
	sprite = spr_snipe_pulse
	distance = 700
	resource_amount = 1
	player_can_use = false
}

function WeaponPlazma() : WeaponBase() constructor {
	damage = 3
	mining = 1
	reload_time = 20
	sp = 20
	resource = "fuel"
	knock_back_force = 3
	sprite = spr_bullet_plazma
	distance = 400
	resource_amount = 0.2
	player_can_use = true
}

function WeaponMetalOrbs() : WeaponBase() constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 7
	resource = "empty"
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 0
	object = obj_bullet_pulse_spread
	resource_amount = 1
	player_can_use = false
}

function WeaponHoming() : WeaponBase() constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 7
	resource = "empty"
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 0
	object = obj_bullet_pulse_spread
	resource_amount = 1
	player_can_use = false
}

weapon_types = {
	pulse: WeaponPulse,
	turret_pulse: WeaponTurretPulse,
	pulse_spread: WeaponPulseSpread,
    pulse_snipe: WeaponPulseSnipe,
	plazma: WeaponPlazma,
	metall_orbs: WeaponMetalOrbs,
	homing: WeaponHoming,
}

function GetWeapon(name) {
	var constr = variable_struct_get(global.weapon_types, name)
	return new constr()
}

init_resource_bullet_names()
