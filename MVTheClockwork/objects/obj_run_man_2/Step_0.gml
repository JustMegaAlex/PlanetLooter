
scr_player_input()

// contact walls
//on_platform = place_meeting(x, y + 1, obj_platform) and (vsp > 0)
//up_free = place_empty(x, y - 1, obj_block)
//down_free = place_empty(x, y + 1, obj_block) and not on_platform
//left_free = place_empty(x - 1, y, obj_block)
//right_free = place_empty(x + 1, y, obj_block)


// detect a platform after collision handling
// otherwise a player will stuck on a platform due to collision
// moving_collider = instance_place(x, y+1, obj_platform)

dashcooldown -= (dashcooldown > 0)
jump_pressed -= (jump_pressed > 0)
swing_attack_pause -= (swing_attack_pause > 0)

// can we move hor?
move_h = key_right*right_free - key_left*left_free

// do we try to move?
input_move_h = key_right - key_left
abs_input_move_h = abs(input_move_h)

if abs(input_move_h)
	dirsign = input_move_h

// enemy
attacker = instance_place(x, y, obj_agro)
	
// chain aim
chain_target = get_chain_target()

// bottom
if down_free {
	collider_vsp = 0
	if left_free and right_free
		collider_hsp = 0
}

switch state {
	case States.walk: {
		// moving hor
		hsp_to = move_h * hsp_max

		// carried by platform
		if on_platform {
			hsp_to += on_platform.hsp
			vsp = on_platform.vsp
		}
		hsp = scr_approach(hsp, hsp_to, acc)

		// control hsp by blocks
		if ((hsp_to >= 0) and !right_free) or ((hsp_to <= 0) and !left_free) {
			hsp = collider_hsp
			hsp_to = collider_hsp
		}

		dir = point_direction(0, 0, hsp, vsp)

		// delay let a player to jump soon after losing ground under him
		// also for smoother jumping
		if down_free {
			on_ground = on_ground_delay
			state = States.fly
			//on_platform = noone
		}

		// jumping
		if key_jump {
			vsp = jump_sp
			state = States.fly
			jumps -= 1
			//on_platform = noone
		}

		if key_dash
			dash()

		if key_shoot
			shoot()
			
		if key_attack
			melee()

		if hsp == 0 and key_special {
			state = States.timeshift
			global.timeshifting = timeshiftammount
			global.timesp = timeshift_sp
		}

		if key_chain and chain_target
			chain()
		
		if abs(hsp) or abs(vsp)
			scr_move_coord(hsp, vsp)
			
		if attacker
			attacker.perform_attack_effect(self)

		break
	}

	case States.fly: {
		// moving hor
		hsp_to = move_h * hsp_max
		var hsp_acc = acc * abs_input_move_h + grav * !abs_input_move_h
		// control hsp by collider
		if ((hsp_to >= 0) and !right_free) or ((hsp_to <= 0) and !left_free) {
			hsp = collider_hsp
			hsp_to = collider_hsp
		}
		hsp = scr_approach(hsp, hsp_to, hsp_acc)
		// handle vertical sp
		vsp = scr_approach(vsp, vsp_max, grav)
		if vsp < (jump_sp * 0.15) and !key_jump_hold
			vsp = jump_sp * 0.15
		// hit ceil
		if ((vsp < 0) and !up_free)
			vsp = 0
		// reset jumps if on ground
		if !down_free {
			if jump_pressed {
				vsp = jump_sp	
			} else {
				state = States.walk
				jumps = jumps_max
				// land on ground
				if vsp > 0
					vsp = 0
			}
		}
		// double jumping
		if key_jump 
			if jumps {
				vsp = jump_sp
				jumps -= 1
			} else {
				jump_pressed = jump_press_delay
			}

		if key_dash
			dash()
			
		if key_chain and chain_target
			chain()

		if key_shoot
			shoot()
		
		if key_attack
			melee()
		
		//vsp = -6
		scr_move_coord(hsp, vsp)
		
		if attacker
			attacker.perform_attack_effect(self)

		break
	}

	case States.dash: {
		if (hsp > 0 and !right_free) or (hsp < 0 and !left_free)
			hsp = 0

		scr_move_coord(hsp, vsp)
		if not --dashing {
			// reset hsp
			hsp = hsp_max * dashdir
			dashcooldown = dashcooldowntime
			if down_free {
				state = States.fly
				break
			}
			state = States.walk
		}
		break
	}

	case States.chaindash: {
		scr_move_coord(hsp, vsp)
		if point_distance(x, y, chain_attached_to.x, chain_attached_to.y) < chain_min_len {
			// linear interpolate using hsp_max as a reference
			hsp *= 0.5
			vsp *= 0.5
			chain_attached_to = noone
			state = States.fly
		}
		break
	}

	case States.onwall: {
		
		break
	}

	case States.timeshift: {
		hsp = collider_hsp
		vsp = collider_vsp
		if abs(hsp) or abs(vsp)
			move_contact(hsp, vsp)
		if not global.timeshifting {
			state = States.walk
		}
		break
	}

	case States.being_hit: {
		if not --being_hit
			state = States.walk
		// control hsp by collider
		if ((hsp_to >= 0) and !right_free) or ((hsp_to <= 0) and !left_free) {
			hsp = collider_hsp
			hsp_to = collider_hsp
		}
		// handle vertical sp
		vsp = scr_approach(vsp, vsp_max, grav)

		if !down_free {
			state = States.walk
			being_hit = 0
			jumps = jumps_max
			// land on ground
			if vsp > 0
				vsp = 0
		}
		scr_move_coord(hsp, vsp)
		break
	}
}
