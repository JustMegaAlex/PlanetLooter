
mouse_over = instance_place(mouse_x, mouse_y, obj_ui_item)
mouse_pressed = false
override_displaying--
if not override_displaying {
	display_text = ""
	image_index = 0
	if mouse_over
		display_text = mouse_over.text
}

if mouse_check_button_pressed(mb_left) {
	mouse_pressed = true
	override_displaying = 0
	if mouse_over {
		mouse_over.upgrader.upgrade()
		audio_play_sound(snd_button, 0, false)
	} else {
		instance_destroy()
	}
}

if point_distance(parent.x, parent.y, obj_looter.x, obj_looter.y) > disconnect_dist
	instance_destroy()
