
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
			state_switch_patrol()
			break
		}
		if dist_to_player < detection_dist {
			warmedup = 1
			state_switch_attack(obj_looter)
			break
		}
		if point_dist(xst, yst) > start_area_radius {
			state_switch_return()
		}
		break
	}

	case "warmup": {
		warmedup += warmup_sp
		if warmedup >= 1 {
			state_switch_search()
			break
		}
		break	
	}

	case "attack": {
		if not --dir_wiggle_delay {
			dir_wiggle_delay = dir_wiggle_change_time * (0.5 + random(0.5))
			dir_wiggle = random_range(-dir_wiggle_magnitude, dir_wiggle_magnitude)
		}
		dir = inst_dir(target)
		if dist_to_player < close_dist
			ai_attack_move_sign = -1
		else if dist_to_player > loose_dist
			state_switch_idle()
		else
			ai_attack_move_sign = 1
		self.set_sp_to(sp.normal * ai_attack_move_sign, dir)
		break
	}

	case "search": {
		self.set_sp_to(sp.normal, dir)
		if dist_to_player < detection_dist_search {
			state_switch_attack(obj_looter)
			break
		}
		if not --searching {
			state_switch_return()
		}
		break
	}

	case "return": {
		dir = point_dir(xst, yst)
		self.set_sp_to(sp.normal, dir)
		if point_dist(xst, yst) < start_area_radius
			state_switch_idle()
		if dist_to_player < detection_dist {
			state_switch_attack(obj_looter)
			break
		}
		break
	}

	case "patrol": {
		if not patrol_point_to {
			state_switch_idle()
			break
		}
		var p = patrol_point_to
		dir = point_dir(p.X, p.Y)
		self.set_sp_to(sp.normal, dir)
		if point_dist(p.X, p.Y) < sp.normal {
			patrol_set_next_point()	
		}
		if dist_to_player < detection_dist {
			state_switch_attack(obj_looter)
		}
		break
	}
}

hsp = approach(hsp, hsp_to + battle_strafe_vec.X, acc)
vsp = approach(vsp, vsp_to + battle_strafe_vec.Y, acc)
scr_move_coord_contact_obj(hsp, vsp, obj_block)

position.set(x, y)
