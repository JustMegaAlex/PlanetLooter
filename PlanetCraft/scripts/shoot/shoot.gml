
function shoot(shoot_dir, spawner, wtype, sp) {
	var weapon = global.weapon_types[$ wtype]
	spawner.reloading = weapon.reload_time
	// spend fuel
	if spawner.object_index == obj_looter
		if not spawner.spend_resource(weapon.resource, 1)
			return 0
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
		self.side = spawner.side
		self.weapon = spawner.weapon
		self.sprite_index = spawner.bullet_sprite
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
		reload_time: 8,
		resource: "empty"
	}
}