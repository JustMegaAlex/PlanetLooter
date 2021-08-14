
if instance_exists(obj_looter) {
	var dist = inst_dist(obj_looter)
	if dist < vision_range {
		if !collision_line(x, y, obj_looter.x, obj_looter.y, obj_block, false, false) {
			angle = inst_dir(obj_looter)
			if !--reloading {
				shoot(angle, id, wtype)
				reloading = reload_time
			}
		}
	}
}
