
scr_player_input()

// contact walls
up_free = place_empty(x, y - 1, obj_block)
// platform_obj detection code is in the end of step event
down_free = place_empty(x, y + 1, obj_block) and not platform_obj
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

if not global.timeshifting {
	// can we move hor?
	move_h = key_right*right_free - key_left*left_free

	// do we try to move?
	input_move_h = key_right - key_left

	if abs(input_move_h)
		// remember input dir for dashing
		dirsign = input_move_h

	// moving hor
	hsp_to = move_h * hsp_max

	// hsp is computed according to player's input
	// and if he is standing on a platform
	// this is the input part
	hsp_inp = scr_approach(hsp_inp, hsp_to, acc)
	vsp = scr_approach(vsp, vsp_max, grav)

	// reset on_wall
	on_wall = false

	// used to fake ground for smoother jumping
	on_ground--

	// delay let a player to jump soon after losing ground under him
	// also for smoother jumping
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
	if key_jump {
		jump_pressed = jump_press_delay
		platform_obj = noone
	}

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
	
	// dashing
	dashcooldown -= dashcooldown > 0
	if not dashing and key_dash and not dashcooldown{
		dashing = dashtime
		dashdir = dirsign
	}
	if dashing {
		vsp = 0
		hsp_inp = dashdir * dashsp
		if not --dashing {
			// reset hsp
			hsp_inp = hsp_max * dashdir
			dashcooldown = dashcooldowntime
		}
	}

	// use timeshift ability only while not moving
	if key_special and not abs(hsp_inp) {
		global.timeshifting = timeshiftammount
		global.timesp = timeshift_sp
	}
}

// riding a platform
hsp = hsp_inp
if platform_obj and not key_jump {
	// finally compute hsp
	if not dashing
		hsp = hsp_inp + platform_obj.hsp
	vsp = platform_obj.vsp
}
		
dir = point_direction(0, 0, hsp, vsp)

// handle collisions
if abs(hsp) or abs(vsp)
	scr_move_coord_contact_obj(hsp, vsp, obj_block)

// detect a platform after collision handling
// otherwise a player will stuck on a platform due to collision
platform_obj = instance_place(x, y+1, obj_platform)

scr_camera_set_center(0, x, y)
