// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function shoot(shoot_dir, our_side, dmg) {
	reloading = reload_time
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
		self.side = our_side
		self.dmg = dmg
	}
	var snd = choose(snd_laser1, snd_laser2, snd_laser3, snd_laser4)
	audio_play_sound(snd, 0, false)
}