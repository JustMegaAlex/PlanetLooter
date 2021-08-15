
function shoot(shoot_dir, spawner, wtype) {
	var weapon = global.weapon_types[$ wtype]
	if object_is_ancestor(spawner.object_index, obj_ship_entity)
		spawner.reloading = weapon.reload_time

	var object_bullet = obj_bullet
	if variable_struct_exists(weapon, "object")
		object_bullet = weapon.object

	with(instance_create_layer(x, y, layer, object_bullet)) {
		self.image_angle = shoot_dir
		self.sprite_index = weapon.sprite
		self.spawner = spawner
		self.side = spawner.side
		self.weapon = weapon
		self.type = wtype
		self.life_distance = weapon.distance
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
		sp: 7,
		resource: "empty",
		knock_back_force: 2,
		sprite: spr_bullet_pulse,
		distance: 400,
		resource_ammount: 1,
	},
	turret_pulse: {
		damage: 2,
		mining: 1,
		reload_time: 20,
		sp: 20,
		resource: "empty",
		knock_back_force: 2,
		sprite: spr_bullet_pulse,
		distance: 500,
		resource_ammount: 1,
	},
	pulse_spread: {
		damage: 1,
		mining: 1,
		reload_time: 90,
		sp: 7,
		resource: "empty",
		knock_back_force: 2,
		sprite: spr_bullet_pulse,
		distance: 400,
		object: obj_bullet_pulse_spread,
		resource_ammount: 1,
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
		resource_ammount: 0.2,
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
		resource_ammount: 0.05,
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
		resource_ammount: 1,
	}
}

init_resource_bullet_names()
