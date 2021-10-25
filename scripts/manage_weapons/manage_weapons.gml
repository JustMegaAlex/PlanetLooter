
function shoot(shoot_dir, spawner, wtype, xx=x, yy=y) {
	var weapon = global.weapon_types[$ wtype]
	if object_is_ancestor(spawner.object_index, obj_ship_entity)
		spawner.reloading = weapon.reload_time

	var object_bullet = obj_bullet
	if variable_struct_exists(weapon, "object")
		object_bullet = weapon.object
	
	if weapon == global.weapon_types.pulse_snipe
		test = true

	with(instance_create_layer(xx, yy, layer, object_bullet)) {
		self.image_angle = shoot_dir
		self.sprite_index = weapon.sprite
		self.spawner = spawner
		self.side = spawner.side
		self.weapon = weapon
		self.sp = weapon.sp
		self.type = wtype
		self.life_distance = weapon.distance
		if object_bullet == obj_bullet_two_phase {
			self.ph1_distance = weapon.ph1_distance
		}
	}
	var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
	//audio_play_sound(snd, 0, false)
}

function init_resource_bullet_names() {
	var weapon_names = variable_struct_get_names(global.weapon_types)
	for (var i = 0; i < array_length(weapon_names); ++i) {
	    var wname = weapon_names[i]
		var resource_name = global.weapon_types[$ wname].resource
		if resource_name != "empty" {
			var rtype = global.resource_types[$ resource_name]
			rtype.is_bullet = true
			rtype.bullet_name = wname
		}
	}
}

global.weapon_types = {
	pulse: {
		damage: 1,
		mining: 1,
		reload_time: 20,
		sp: 14,
		resource: "empty",														  
		knock_back_force: 2,
		sprite: spr_bullet_pulse,
		distance: 700,
		resource_amount: 1,
		player_can_use: false,

		object: obj_bullet_two_phase,
		ph2_sp: 7,
		ph2_img: 1,
		ph1_distance: 120,
	},
	turret_pulse: {
		damage: 2,
		mining: 1,
		reload_time: 20,
		sp: 20,
		resource: "empty",
		knock_back_force: 2,
		sprite: spr_common_pulse,
		distance: 500,
		resource_amount: 1,
		player_can_use: false
	},
	pulse_spread: {
		damage: 1,
		mining: 1,
		reload_time: 90,
		sp: 7,
		resource: "empty",
		knock_back_force: 2,
		sprite: spr_bullet_pulse,
		distance: 0,
		object: obj_bullet_pulse_spread,
		resource_amount: 1,
		player_can_use: false
	},
    pulse_snipe: {
		damage: 1,
		mining: 1,
		reload_time: 90,
		sp: 15,
		resource: "empty",
		knock_back_force: 2,
		sprite: spr_common_pulse,
		distance: 700,
		resource_amount: 1,
		player_can_use: false
	},
	plazma: {
		damage: 3,
		mining: 1,
		reload_time: 20,
		sp: 20,
		resource: "fuel",
		knock_back_force: 3,
		sprite: spr_bullet_plazma,
		distance: 400,
		resource_amount: 0.2,
		player_can_use: true
	},
	metall_orbs: {
		damage: 0.25,
		mining: 1,
		reload_time: 5,
		sp: 20,
		resource: "metall",
		knock_back_force: 1,
		sprite: spr_bullet_metall_orb,
		distance: 250,
		resource_amount: 0.05,
		player_can_use: true
	},
	homing: {
		damage: 1,
		mining: 0.5,
		reload_time: 13,
		sp: 20,
		resource: "bullet_homing",
		knock_back_force: 1,
		sprite: spr_bullet_homing,
		object: obj_bullet_homing,
		distance: 1000,
		resource_amount: 1,
		player_can_use: true
	}
}

init_resource_bullet_names()
