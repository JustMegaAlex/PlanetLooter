
mouse_over = instance_place(mouse_x, mouse_y, obj_ui_item)
mouse_pressed = false
override_displaying--
if not override_displaying {
	display_text = ""
	if mouse_over
		display_text = mouse_over.text
}

if mouse_check_button(mb_left) {
	mouse_pressed = true
	override_displaying = 0
	if mouse_over {
		mouse_over.action_method()
	} else {
		instance_destroy()
	}
}
