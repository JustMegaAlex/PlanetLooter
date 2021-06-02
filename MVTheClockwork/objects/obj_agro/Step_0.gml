

switch state {
	case Agro.wander: {
		if (hsp > 0 and !right_free) or (hsp < 0 and !left_free) {
			hsp = 0
			dirsign = -dirsign
			hsp_to = hsp_max * dirsign
		}
		hsp = scr_approach(hsp, hsp_to, acc)
		if check_player_in_sight() {
			state = Agro.attack
			hsp_to = 0
			prepairing_attack = attack_pause_time
			throwing = 0
		}
		break
	}
	case Agro.attack: {
		if (hsp > 0 and !right_free) or (hsp < 0 and !left_free) {
			hsp = 0
			throwing = 0
		}

		hsp = scr_approach(hsp, hsp_to, acc)

		if prepairing_attack {
			prepairing_attack--
			if not prepairing_attack {
				hsp_to = attack_throw_sp * dirsign
				throwing = attack_throw_dist
			} else
				break
		}
		
		throwing -= abs(hsp)
		hsp = scr_approach(hsp, hsp_to, throw_acc)
		if throwing <=0 {
			hsp_to = 0
			if check_player_in_sight() {
				prepairing_attack = attack_pause_time
				break
			}
			dirsign = -dirsign
			if check_player_in_sight() {
				prepairing_attack = attack_pause_time
				break
			}
			state = Agro.wander
		}
		break
	}

	case Agro.being_hit: {
		if not --being_hit
			state = Agro.wander
		// control hsp by collider
		if ((hsp_to >= 0) and !right_free) or ((hsp_to <= 0) and !left_free) {
			hsp = 0
		}

		scr_move_coord(hsp, vsp)
		break
	}
}

scr_move_coord(hsp, 0)










