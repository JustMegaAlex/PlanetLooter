
var dist = point_distance(x, y, obj_looter.x, obj_looter.y)
if dist < min_dist {
	instance_destroy()
} else if dist < pull_dist {
	var sp = sp_base * sp_ratio / dist
	dir = point_direction(x, y, obj_looter.x, obj_looter.y)
	scr_move(sp, dir)
}
