
if instance_exists(obj_man) {
	var dist_to_man = point_distance(x, y, obj_man.x, obj_man.y)
	if dist_to_man < magnet_dist and magnet_delay <= 0 {
		if dist_to_man < 10 {
			make_effect()
			instance_destroy()
		}
		sp = scr_approach(sp, spmax, acc)
		dir = point_direction(x, y, obj_man.x, obj_man.y)
		scr_move(sp, dir)
	} else if sp {
		sp = scr_approach(sp, 0, acc)
		scr_move(sp, dir)
	}
}

magnet_delay--
