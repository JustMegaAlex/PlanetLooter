
event_inherited()

function step_event() {
	key_left = keyboard_check_pressed(vk_left)
	key_right = keyboard_check_pressed(vk_right)
	key_up = keyboard_check_pressed(vk_up)
	key_down = keyboard_check_pressed(vk_down)
	
	move_h = key_right - key_left
	move_v = key_down - key_up
	move_v = move_v * !move_h
	
	if try_move()
		pass_turn()
}
