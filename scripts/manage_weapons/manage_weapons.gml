
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

function WeaponBase(name) constructor {
	self.name = name
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
	ph2_sp = 7
	ph2_img = 1
	ph1_distance = 0
	object_bullet = obj_bullet

	shoot = function(shoot_dir, spawner) {
		var inst = instance_create_layer(spawner.x, spawner.y, "Instances", object_bullet)
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

function WeaponPulse(name) : WeaponBase(name) constructor {
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
	ph2_sp = 7
	ph2_img = 1
	ph1_distance = 120
}

function WeaponPulseTwoPhase(name) : WeaponBase(name) constructor {
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
	ph2_sp = 7
	ph2_img = 1
	ph1_distance = 120
	object_bullet = obj_bullet_two_phase
}

function WeaponTurretPulse(name) : WeaponBase(name) constructor {
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

function WeaponPulseSpread(name) : WeaponBase(name) constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 7
	resource = "empty"
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 500
	object_bullet = obj_bullet_pulse_spread
	resource_amount = 1
	player_can_use = false
	ph1_distance = 120
}

function WeaponPulseSnipe(name) : WeaponBase(name) constructor {
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

function WeaponPlazma(name) : WeaponBase(name) constructor {
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
	
	start_xshift = 8
	start_shift_dir = 1
	
	shoot = function(shoot_dir, spawner) {
		var point = new Vec2d(spawner.x, spawner.y)
		var dir = shoot_dir + 90 * start_shift_dir
		point.add_polar(start_xshift, dir)
		start_shift_dir *= -1
		var inst = instance_create_layer(point.X, point.Y, "Instances", object_bullet)
		inst.image_angle = shoot_dir
		inst.sprite_index = sprite
		inst.spawner = spawner
		inst.side = spawner.side
		inst.weapon = self
		inst.sp = sp
		inst.life_distance = distance
		var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
		//audio_play_sound(snd, 0, false)
	}
}

function WeaponMetalOrbs(name) : WeaponBase(name) constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 7
	resource = "metall"
	knock_back_force = 2
	sprite = spr_bullet_pulse
	distance = 0
	object = obj_bullet_pulse_spread
	resource_amount = 1
	player_can_use = false
}

function WeaponHoming(name) : WeaponBase(name) constructor {
	damage = 1
	mining = 1
	reload_time = 90
	sp = 7
	resource = "bullet_homing"
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
	pulse_two_phase: WeaponPulseTwoPhase,
}

function GetWeapon(name) {
	var constr = variable_struct_get(global.weapon_types, name)
	return new constr(name)
}

init_resource_bullet_names()
