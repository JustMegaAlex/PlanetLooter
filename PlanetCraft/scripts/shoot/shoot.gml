
function shoot(shoot_dir, spawner, wtype, sp) {
	var weapon = global.weapon_types[$ wtype]
	spawner.reloading = weapon.reload_time
	// spend fuel
	if spawner.object_index == obj_looter
		if not spawner.spend_resource(weapon.resource, 1)
			return 0
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
		self.sprite_index = weapon.sprite
		self.side = spawner.side
		self.weapon = weapon
		self.type = wtype
		self.life_distance = weapon.distance
		if sp != undefined
			self.sp = sp
	}
	var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
	audio_play_sound(snd, 0, false)
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
		distance: 400
	},
	plazma: {
		damage: 3,
		mining: 1,
		reload_time: 20,
		sp: 20,
		resource: "empty",
		knock_back_force: 3,
		sprite: spr_bullet_plazma,
		distance: 400
	},
}