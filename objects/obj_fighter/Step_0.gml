
if mouse_check_button_pressed(mb_left) {
	target_point = new Vec2d(mouse_x, mouse_y)
	CmpMovement.init_movement(target_point)
}


switch state {
	case "idle": {
		if target_point {
			state = "move"
		}
		break
	}
	case "move": {
		var dir_to = point_dir(target_point.X, target_point.Y)
		var diff = angle_difference(dir_to, dir)
		if abs(diff) < rot_sp
			dir = dir_to
		else
			dir += sign(diff) * rot_sp

		CmpMovement.update_velocity(velocity, position, dir)
		if CmpMovement.destination_reached() {
			state = "idle"   
			target_point = null
		}
		break
	}
}

scr_move_coord_contact_glide(velocity.X, velocity.Y, obj_block)
position.set(x, y)