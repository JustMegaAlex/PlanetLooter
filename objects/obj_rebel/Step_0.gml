
reloading--

if target and !reloading {
	shoot(dir, id, use_weapon)
}

dist_to_player = inst_dist(obj_looter)

switch state {
	case "idle": {
		if array_length(move_route) {
			state_switch_on_route(move_route)
			on_route_finished_method = state_switch_mining
		}
		if point_dist(xst, yst) > start_area_radius {
			ai_travel_to_point(xst, yst)
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
        compute_strafe_vec()
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
		break
	}

	case "on_route": {
		var block = instance_place(x, y, obj_block)
		if block {
			var new_dir = point_dir(block.x, block.y)
			dir = new_dir
		}
		if move_route_point_to == undefined
			if update_route() == undefined {
				var on_finished = on_route_finished_method
				on_route_finished_method = undefined
				if on_finished != undefined
					on_finished()
				break
			}
		var p = move_route_point_to
		if p == undefined {
			state_switch_idle()
			move_to_set_coords(xst, yst)
			break
		}
		set_dir_to(point_dir(p.X, p.Y))
		self.set_sp_to(sp.normal, dir)
		var _dist = point_dist(p.X, p.Y)
		var _sp = self.get_abs_sp()
		if _dist < sp.normal
			update_route()
		else if (_dist < sp.normal * 2) and (_sp > sp.normal * 0.1)
			self.set_sp_to(_sp * 0.5, dir)
		break
	}

	case "mining": {
		if !instance_exists(mining_block) {
			get_collectibles_around_me()
			target = noone
			state_switch_collect()
			break
		}
		var p = get_instance_center(mining_block)
		set_dir_to(point_dir(p.X, p.Y))
		break
	}

	case "collect": {
		if check_cargo_full(1) {
			ai_return_to_home()
			break
		}
		if colliding_with {
			if !collect_wait_on_collision-- {
				collect_wait_on_collision = 30
				ai_start_mining_or_idle()
				break
			}
		}
		var list = collectibles_around_me
		current_collectible = list[| 0]
		if current_collectible == undefined {
			ai_start_mining_or_idle()
			break
		}
		var _exit = false
		while !instance_exists(current_collectible) {
			ds_list_delete(list, 0)
			if ds_list_size(list) == 0 {
				ai_start_mining_or_idle()
				_exit = true
				break
			}
			current_collectible = list[| 0]
		}
		if _exit
			break
		set_dir_to(inst_dir(current_collectible))
		self.set_sp_to(sp.normal * 0.25, dir)
		if inst_dist(current_collectible) < current_collectible.pull_dist
			self.set_sp_to(0, 0)
		break
	}
}

update_dir()

hsp = approach(hsp, hsp_to + battle_strafe_vec.X, acc)
vsp = approach(vsp, vsp_to + battle_strafe_vec.Y, acc)
colliding_with = scr_move_coord_contact_obj(hsp, vsp, obj_block)

position.set(x, y)
