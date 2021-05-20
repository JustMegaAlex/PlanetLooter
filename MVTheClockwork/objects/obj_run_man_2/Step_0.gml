
scr_player_input()

// contact walls
up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block) and not platform_obj
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)


// can we move hor?
move_h = key_right*right_free - key_left*left_free

// do we try to move?
input_move_h = key_right - key_left

switch state {
	case States.walk: {
		// moving hor
		hsp_to = move_h * hsp_max
		hsp = scr_approach(hsp, hsp_to, acc)

		// block hor sp if wall contact
		if ((hsp > 0) and !right_free) or ((hsp < 0) and !left_free)
			hsp = 0

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
		}
		
		// handle collisions
		if abs(hsp) or abs(vsp)
			scr_move_coord_contact_obj(hsp, vsp, obj_block)

		break
	}

	case States.fly: {
		// moving hor
		hsp_to = move_h * hsp_max
		hsp = scr_approach(hsp, hsp_to, acc)
		// block hor sp if wall contact
		if ((hsp > 0) and !right_free) or ((hsp < 0) and !left_free) {
			hsp = 0
		}
		// handle vertical sp
		vsp = scr_approach(vsp, vsp_max, grav) 
		// hit ceil
		if ((vsp < 0) and !up_free)
			vsp = 0
		// reset jumps if on ground
		if !down_free {
			state = States.walk
			jumps = jumps_max
			// land on ground
			if vsp > 0
				vsp = 0
		}
		// double jumping
		if key_jump and jumps {
			vsp = jump_sp
			jumps -= 1
		}
		// handle collisions
		if abs(hsp) or abs(vsp)
			scr_move_coord_contact_obj(hsp, vsp, obj_block)
		break
	}
	
	case States.dash: {

		break
	}
	
	case States.onwall: {
		
		break
	}
	
	case States.timeshift: {
		
		break
	}
}


// detect a platform after collision handling
// otherwise a player will stuck on a platform due to collision
platform_obj = instance_place(x, y+1, obj_platform)

scr_camera_set_center(0, x, y)
