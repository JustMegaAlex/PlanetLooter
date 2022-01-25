
collision_circle_list(x, y, pull_dist, obj_ship_entity,
					  false, false, collectors, true)
var nearest = noone
for (var i = 0; i < ds_list_size(collectors); ++i) {
    var inst = collectors[| i]
	if inst.is_collecting_things {
		nearest = inst
		break
	}
}
ds_list_clear(collectors)

if nearest != noone {
	var dist = point_distance(x, y, nearest.x, nearest.y)
	if dist < sp {
		if nearest.add_resource(resource_type, 1) {
			audio_play_sound(snd_pick, 0, false)
			instance_destroy()
		}

	} else {
		inertial_moving = false
		sp = sp_base * sp_ratio / dist
		dir = point_direction(x, y, nearest.x, nearest.y)
		scr_move(sp, dir)
	}
}

if inertial_moving {
	sp = approach(sp, 0, decc)
	scr_move(sp, dir)
}
