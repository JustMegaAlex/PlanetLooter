
event_inherited()

function step_event() {
	key_left = keyboard_check(vk_left)
	key_right = keyboard_check(vk_right)
	key_up = keyboard_check(vk_up)
	key_down = keyboard_check(vk_down)
	
	move_h = key_right - key_left
	move_v = key_down - key_up
	move_v = move_v * !move_h
	
	if try_move()
		pass_turn()
}
