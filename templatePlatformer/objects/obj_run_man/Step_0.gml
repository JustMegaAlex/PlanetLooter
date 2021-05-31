
scr_player_input()

dashcooldown -= (dashcooldown > 0)
jump_pressed -= (jump_pressed > 0)

// can we move hor?
move_h = key_right*right_free - key_left*left_free

// do we try to move?
input_move_h = key_right - key_left
abs_input_move_h = abs(input_move_h)

if abs(input_move_h)
	dirsign = input_move_h

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
		}

		// jumping
		if key_jump {
			vsp = jump_sp
			state = States.fly
			jumps -= 1
			on_platform = noone
		}

		if key_dash
			dash()
		
		if abs(hsp) or abs(vsp)
			scr_move_coord(hsp, vsp)

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
			
		//vsp = -6
		scr_move_coord(hsp, vsp)

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

	case States.onwall: {
		
		break
	}

}
