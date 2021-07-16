
reloading--

if target and !reloading
	shoot(dir, id)

dist_to_player = point_distance(x, y, obj_looter.x, obj_looter.y)

switch state {
	case "idle": {
		if dist_to_player < detection_dist {
			target = obj_looter
			state = "enclose"
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
		dir = point_direction(x, y, obj_looter.x, obj_looter.y)
		self.set_sp_to(sp.normal, dir)
		if dist_to_player < close_dist
			state = "distantiate"
		else if dist_to_player > loose_dist {
			state = "idle"
			hsp_to = 0
			vsp_to = 0
			target = noone
		}
		break
	}

	case "distantiate": {
		dir = point_direction(x, y, obj_looter.x, obj_looter.y)
		self.set_sp_to(sp.normal, dir)
		if dist_to_player > close_dist
			state = "enclose"
		break
	}
}

hsp = approach(hsp, hsp_to, acc)
vsp = approach(vsp, vsp_to, acc)
scr_move_coord_contact_obj(hsp, vsp, obj_block)
