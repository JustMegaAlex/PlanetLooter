
scr_player_input()

is_colliding = false

// contact walls
on_platform = place_meeting(x, y + vsp_max, obj_platform) or last_on_platform
up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block) and not on_platform
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

last_on_platform = false

// detect a platform after collision handling
// otherwise a player will stuck on a platform due to collision
// moving_collider = instance_place(x, y+1, obj_platform)

dashcooldown -= (dashcooldown > 0)

// can we move hor?
move_h = key_right*right_free - key_left*left_free

// do we try to move?
input_move_h = key_right - key_left

if abs(input_move_h)
	dirsign = input_move_h

//// handle collisions with moving platforms
// side
switch moving_collision {
	case MovingCollisions.none: {
		if key_left and last_platform_left {
			if moving_collider.hsp > 0 {
				moving_collision = MovingCollisions.left_from
				collider_hsp = moving_collider.hsp
				hsp_restricted_by_collision = true
				break
			}
			moving_collision = MovingCollisions.left_to
			break
		}

		if key_right and last_platform_right {
			if moving_collider.hsp < 0 {
				moving_collision = MovingCollisions.right_from
				collider_hsp = moving_collider.hsp
				hsp_restricted_by_collision = true
				break
			}
			moving_collision = MovingCollisions.right_to
		}
		break
	}
	case MovingCollisions.left_to: {
		moving_collider = instance_place(x + hsp + sign(hsp), y, obj_platform)
		if not moving_collider {
			moving_collision = MovingCollisions.none
			hsp_max = hsp_max_base
			break
		}
		hsp_max = abs(moving_collider.hsp)
		if not key_left {
			last_platform_left = false
			moving_collision = MovingCollisions.none
			hsp_max = hsp_max_base
		}
		break
	}
	case MovingCollisions.right_to: {
		moving_collider = instance_place(x + hsp + sign(hsp), y, obj_platform)
		if not moving_collider {
			moving_collision = MovingCollisions.none
			hsp_max = hsp_max_base
			break
		}
		hsp_max = abs(moving_collider.hsp)
		if not key_right{
			last_platform_right = false
			moving_collision = MovingCollisions.none
			hsp_max = hsp_max_base
		}
		break
	}
	case MovingCollisions.left_from: {
		moving_collider = instance_place(x + sign(hsp), y, obj_platform)
		if not moving_collider or key_right {
			moving_collision = MovingCollisions.none
			hsp_restricted_by_collision = false
			if moving_collider
				hsp = moving_collider.hsp
			break
		}
		break
	}
	case MovingCollisions.right_from: {
		moving_collider = instance_place(x + sign(hsp), y, obj_platform)
		if not moving_collider or key_left {
			moving_collision = MovingCollisions.none
			hsp_restricted_by_collision = false
			if moving_collider
				hsp = moving_collider.hsp
			break
		}
		break
	}
}
last_platform_left = false
last_platform_right = false

// bottom
collider_hsp = 0
collider_vsp = 0
if on_platform {
	// moving_collider might be set in side collision code
	moving_collider = instance_place(x, y + vsp_max, obj_platform)
	if not moving_collider or key_jump
		on_platform = false
	else {
		collider_hsp = moving_collider.hsp
		collider_vsp = moving_collider.vsp
	}
}

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

		if key_dash
			dash()
			
		if key_shoot
			shoot()
	
		if hsp == 0 and key_special {
			state = States.timeshift
			global.timeshifting = timeshiftammount
			global.timesp = timeshift_sp
		}

		// handle collisions
		res_hsp = hsp + collider_hsp
		res_vsp = vsp
		if on_platform
			res_vsp = collider_vsp
		if hsp_restricted_by_collision
			hsp = collider_hsp
		if abs(res_hsp) or abs(res_vsp)
			move_contact(res_hsp, res_vsp)

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
			// land on platform
			if on_platform
				vsp = collider_vsp
			// land on ground
			else if vsp > 0
				vsp = 0
		}
		// double jumping
		if key_jump and jumps {
			vsp = jump_sp
			jumps -= 1
		}

		// handle collisions
		if abs(hsp) or abs(vsp)
			move_contact(hsp, vsp)

		if key_dash
			dash()
			
		if key_shoot
			shoot()

		break
	}

	case States.dash: {
		move_contact(hsp, vsp)
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

	case States.timeshift: {
		hsp = collider_hsp
		vsp = collider_vsp
		if hsp_restricted_by_collision
			hsp = collider_hsp
		if abs(hsp) or abs(vsp)
			move_contact(hsp, vsp)
		if not global.timeshifting {
			state = States.walk
		}
		break
	}
}

scr_camera_set_center(0, x, y)
