
event_inherited()

function step_event() {
	key_left = keyboard_check(vk_left)
	key_right = keyboard_check(vk_right)
	key_up = keyboard_check(vk_up)
	key_down = keyboard_check(vk_down)
	
	move_h = key_right - key_left
	move_v = key_down - key_up
	move_v = move_v * !move_h
	
	if abs(move_h) or abs(move_v) {
		var ii = i + move_h
		var jj = j + move_v
		if grid_at(ii, jj) == noone {
			move_to(ii, jj)
			pass_turn()
		}
	}
}
