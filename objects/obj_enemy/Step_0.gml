
reloading--

if target and !reloading and (warmedup >= 1) {
	var shdir = dir + random(shoot_dir_wiggle) * choose(-1, 1)
	shoot(shdir, id, use_weapon)
}

battle_strafe_vec.set(0, 0)
if target
	compute_strafe_vec()

dist_to_player = inst_dist(obj_looter)


switch state {
	case "idle": {
		if is_patrol {
			state = "patrol"
			break
		}
		if dist_to_player < detection_dist {
			state_set_attacking()
			break
		}
		if point_dist(xst, yst) > start_area_radius {
			state = "return"
		}
		break
	}

	case "warmup": {
		warmedup += warmup_sp
		if warmedup >= 1 {
			state = "search"
			searching = search_time
			break
		}
		break	
	}

	case "wander": {
		if dist_to_player < detection_dist {
			target = obj_looter
			state = "enclose"
		}
		break
	}

	case "enclose": {
		if not --dir_wiggle_delay {
			dir_wiggle_delay = dir_wiggle_change_time * (0.5 + random(0.5))
			dir_wiggle = random_range(-dir_wiggle_magnitude, dir_wiggle_magnitude)
		}
		dir = inst_dir(obj_looter)
		//self.set_sp_to(sp.normal, dir + dir_wiggle)
		self.set_sp_to(sp.normal, dir)
		if dist_to_player < close_dist
			state = "distantiate"
		else if dist_to_player > loose_dist {
			state = "idle"
			self.set_sp_to(0, dir)
			target = noone
		}
		break
	}

	case "distantiate": {
		if not --dir_wiggle_delay {
			dir_wiggle_delay = dir_wiggle_change_time * (0.5 + random(0.5))
			dir_wiggle = random_range(-dir_wiggle_magnitude, dir_wiggle_magnitude)
		}
		dir = inst_dir(obj_looter)
		//self.set_sp_to(-sp.normal, dir + dir_wiggle)
		self.set_sp_to(-sp.normal, dir)
		if dist_to_player > close_dist
			state = "enclose"
		break
	}

	case "search": {
		self.set_sp_to(sp.normal, dir)
		if dist_to_player < detection_dist_search {
			target = obj_looter
			state = "enclose"
			break
		}
		if not --searching {
			state = "return"
		}
		break
	}

	case "return": {
		dir = point_dir(xst, yst)
		self.set_sp_to(sp.normal, dir)
		if point_dist(xst, yst) < start_area_radius {
			state = "idle"
			self.set_sp_to(0, dir)
			target = noone
		}
		if dist_to_player < detection_dist {
			target = obj_looter
			state = "enclose"
			trigger_friendly_units()
			break
		}
		break
	}
	
	case "patrol": {
		if dist_to_player < detection_dist {
			state_set_attacking()
			break
		}
		var p = patrol_point_to
		dir = point_dir(p.X, p.Y)
		self.set_sp_to(sp.normal, dir)
		if point_dist(p.X, p.Y) < sp.normal {
			patrol_set_next_point()	
		}
		break
	}
}

hsp = approach(hsp, hsp_to + battle_strafe_vec.X, acc)
vsp = approach(vsp, vsp_to + battle_strafe_vec.Y, acc)
scr_move_coord_contact_obj(hsp, vsp, obj_block)
