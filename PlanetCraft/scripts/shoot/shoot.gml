
function shoot(shoot_dir, spawner) {
	reloading = reload_time
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
		self.side = spawner.side
		self.dmg = spawner.dmg
		self.knock_back_force = spawner.knock_back_force
	}
	var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
	audio_play_sound(snd, 0, false)
}