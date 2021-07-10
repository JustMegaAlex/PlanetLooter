
var dist = point_distance(x, y, obj_looter.x, obj_looter.y)
if dist < min_dist {
	if not obj_looter.check_resource_full(resource_type) {
		obj_looter.add_resource(resource_type, 1)
		instance_destroy()	
	}
} else if dist < pull_dist {
	var sp = sp_base * sp_ratio / dist
	dir = point_direction(x, y, obj_looter.x, obj_looter.y)
	scr_move(sp, dir)
}
