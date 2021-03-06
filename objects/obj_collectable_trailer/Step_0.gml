
var dist = point_distance(x, y, obj_looter.x, obj_looter.y)
if dist < min_dist {
	if not obj_looter.check_cargo_full(1) {
		obj_looter.add_resource(resource_type, 1)
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
