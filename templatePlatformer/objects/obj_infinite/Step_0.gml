

repeat(4) {

	// contact walls
	up_free = place_empty(x, y - 1, obj_block)
	down_free = place_empty(x, y + 1, obj_block)
	left_free = place_empty(x - 1, y, obj_block)
	right_free = place_empty(x + 1, y, obj_block)

	//// state control
	if on_wall {
		input_move_h = -input_move_h
		key_jump = true
	} else if not down_free {
		if place_meeting(x, y, obj_bound) {
			key_jump = true
			flying = random_range(flying_time_min, flying_time_max)
		}
	} else {
		if (abs(vsp) < grav) and chance(0.5) {
			build_block("vertical")	
		}
		if not flying-- {
			flying = random_range(flying_time_min, flying_time_max)
			build_block("random")
		}
	}

	key_right = input_move_h > 0
	key_left = input_move_h < 0
	move_h = key_right*right_free - key_left*left_free

	if abs(input_move_h)
		dirsign = input_move_h

	// moving hor
	hsp_to = move_h * hsp_max

	hsp = scr_approach(hsp, hsp_to, acc)
	vsp = scr_approach(vsp, vsp_max, grav)

	// reset on_wall
	on_wall = false

	// used to fake ground for smoother jumping
	on_ground--

	if !down_free
		on_ground = on_ground_delay

	// on wall
	if ((!right_free and key_right) or (!left_free and key_left)) and abs(input_move_h)
		on_wall = true
	

	// handle vertical sp
	// hit ceil
	if ((vsp < 0) and !up_free) {
		vsp = 0
	}
	// reset jumps if on ground
	else if !down_free {
		jumps = jumps_max
		// land on ground
		if vsp > 0
			vsp = 0
	}

	// jumping
	if key_jump
		jump_pressed = jump_press_delay

	if jump_pressed {
		jump_pressed--
		// wall jump
		if on_wall {
			jumps = jumps_max
			jump_pressed = 0
			vsp = jump_sp
			hsp = -input_move_h * hsp_max
		}
		// ordinary jump
		else if jumps {
			vsp = jump_sp
			jumps -= down_free and !on_ground
			jump_pressed = 0
		}
	}

	// block hor sp if wall contact
	if ((hsp > 0) and !right_free) or ((hsp < 0) and !left_free)
		hsp = 0

	dashcooldown -= dashcooldown > 0
	if not dashing and key_dash and not dashcooldown{
		dashing = dashtime
		dashdir = dirsign
	}
	if dashing {
		vsp = 0
		hsp = dashdir * dashsp
		if not --dashing {
			hsp = hsp_max * dashdir
			dashcooldown = dashcooldowntime
		}
	}


	dir = point_direction(0, 0, hsp, vsp)

	// handle collisions
	if abs(hsp) or abs(vsp)
		scr_move_coord_contact_obj(hsp, vsp, obj_block)

	//scr_camera_set_center(0, x, y)

	// reset keys
	key_right = false
	key_left = false
	key_jump = false
}
