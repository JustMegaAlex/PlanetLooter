
reloading--

enemy_in_sight = target != noone

battle_strafe_vec.set(0, 0)	

dist_to_player = inst_dist(obj_looter)

switch state {
	case "idle": {
		if dist_to_player < detection_dist {
			state_switch_attack(obj_looter, true)
			break
		}
		if point_dist(xst, yst) > start_area_radius {
			state_switch_on_route(xst, yst)
		}
		break
	}

    case "attack_snipe": {
        compute_strafe_vec()
        set_dir_to(inst_dir(target))
		if dist_to_player < attack_snipe_min_dist
			ai_attack_move_sign = -1
        else if dist_to_player > attack_snipe_max_dist 
            ai_attack_move_sign = 1
        else
            ai_attack_move_sign = 0
		if dist_to_player > loose_dist
			state_switch_idle()
		self.set_sp_to(sp.normal * ai_attack_move_sign, dir)
		break
    }

	case "attack": {
        compute_strafe_vec()
		ensure_out_of_terrain()
		self.set_dir_to(inst_dir(target))
        //if dist_to_player > attack_max_dist {
        //    move_to_set_coords(target.x, target.y)
		//	enemy_in_sight = false
        //}
		if dist_to_player > loose_dist {
			state_switch_idle()
			break
		}
		if collision_line(x, y, target.x, target.y, obj_block, false, true)
				or dist_to_player > attack_max_dist {
			is_pursuing_target = true
			ai_travel_to_point(target.x, target.y)
			enemy_in_sight = false
			break
		}

        var p = move_route_point_to
        if !p {
			self.set_sp_to(0, dir)
			break   
        }
        set_dir_to(point_dir(p.X, p.Y))
        self.set_sp_to(sp.normal, dir)
        if point_dist(p.X, p.Y) < global.ai_mobs_reach_point_treshold
            update_route()
        break
	}

	case "return": {
		set_dir_to(point_dir(xst, yst))
		self.set_sp_to(sp.normal, dir)
		if point_dist(xst, yst) < start_area_radius
			state_switch_idle()
		if dist_to_player < detection_dist {
			state_switch_attack(obj_looter, true)
			break
		}
		break
	}

	case "on_route": {
        enemy_in_sight = false

		if is_pursuing_target {
			if !collision_line(x, y, target.x, target.y, obj_block, false, true)
					and dist_to_player <= attack_max_dist {
				reset_route()
                try_move_forward(global.grid_size * 0.5)
				state_switch_attack(target)
				is_pursuing_target = false
				break
			}	
		}

		if not move_route_point_to
			update_route()
		var p = move_route_point_to
		if p != undefined {
            var next_p = iter_move_route.get(1)
            if next_p != undefined {
                if !collision_line(x, y, next_p.X, next_p.Y, obj_block, false, true) {
                    p = update_route()
                }
            }
        }
        if p == undefined {
			state_switch_idle()
			move_to_set_coords(xst, yst)
			break
		}

		self.set_dir_to(point_dir(p.X, p.Y))
		self.set_sp_to(sp.normal, dir)
		if point_dist(p.X, p.Y) < global.ai_mobs_reach_point_treshold
			update_route()
		if (dist_to_player < detection_dist) and !is_pursuing_target
			state_switch_attack(obj_looter, true)
		break
	}
}

update_dir()

if enemy_in_sight and !reloading and (warmedup >= 1) {
	shoot(dir, id, use_weapon)
}

hsp = approach(hsp, hsp_to + battle_strafe_vec.X, acc)
vsp = approach(vsp, vsp_to + battle_strafe_vec.Y, acc)

position.set(x, y)
colliding_with = instance_place(x, y, obj_block)

if global.enemy_collisions_on {
	scr_move_coord_contact_obj(hsp, vsp, obj_block)
} else {
	scr_move_coord(hsp, vsp)
}
