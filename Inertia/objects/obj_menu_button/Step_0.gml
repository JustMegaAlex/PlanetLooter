

interacting = collision_point(mouse_x, mouse_y, id, false, false)

/// lightening if interaction
if interacting {
	
	image_index = _interact_img
	
	// just pressed
	if mouse_check_button_pressed(mb_left) {
		image_index = _checked_img
		room_goto(room_to_start)
	}
}
else {
	image_index = _default
}