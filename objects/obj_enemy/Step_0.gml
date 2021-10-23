
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
			state_switch_on_route(xst, yst)
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
		set_dir_to(inst_dir(target))
		if dist_to_player < attack_min_dist
			ai_attack_move_sign = -1
        else if dist_to_player > attack_max_dist 
            ai_attack_move_sign = 1
        else
            ai_attack_move_sign = 0
		if dist_to_player > loose_dist
			state_switch_idle()
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
			state_switch_idle()
		}
		break
	}

	case "return": {
		set_dir_to(point_dir(xst, yst))
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
		if not move_route_point_to
			patrol_update_move_to()
		var p = move_route_point_to
		set_dir_to(point_dir(p.X, p.Y))
		self.set_sp_to(sp.normal, dir)
		if point_dist(p.X, p.Y) < sp.normal
			patrol_update_move_to()
		if dist_to_player < detection_dist
			state_switch_attack(obj_looter)
		break
	}

	case "on_route": {
		if not move_route_point_to
			update_route()
		var p = move_route_point_to
		if p == undefined {
			state_switch_idle()
			move_to_set_coords(xst, yst)
			break
		}
		set_dir_to(point_dir(p.X, p.Y))
		self.set_sp_to(sp.normal, dir)
		if point_dist(p.X, p.Y) < sp.normal
			update_route()
		if dist_to_player < detection_dist
			state_switch_attack(obj_looter)
		break
	}
}

update_dir()

hsp = approach(hsp, hsp_to + battle_strafe_vec.X, acc)
vsp = approach(vsp, vsp_to + battle_strafe_vec.Y, acc)
scr_move_coord_contact_obj(hsp, vsp, obj_block)

position.set(x, y)
