
var dist = point_distance(x, y, obj_looter.x, obj_looter.y)
if dist < min_dist {
	if obj_looter.add_resource(resource_type, 1) {
		audio_play_sound(snd_pick, 0, false)
		instance_destroy()
	}

} else if dist < pull_dist {
	inertial_moving = false
	sp = sp_base * sp_ratio / dist
	dir = point_direction(x, y, obj_looter.x, obj_looter.y)
	scr_move(sp, dir)
}

if inertial_moving {
	sp = approach(sp, 0, decc)
	scr_move(sp, dir)
}
