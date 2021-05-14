function scr_player_input() {

	// controls
	key_left = keyboard_check(vk_left)||keyboard_check(ord("A"))
	key_right = keyboard_check(vk_right)||keyboard_check(ord("D"))
	key_up = keyboard_check(vk_up)||keyboard_check(ord("S"))
	key_down = keyboard_check(vk_down)||keyboard_check(ord("W"))
	key_left_pressed = keyboard_check_pressed(vk_left)||keyboard_check(ord("A"))
	key_right_pressed = keyboard_check_pressed(vk_right)||keyboard_check(ord("D"))
	key_up_pressed = keyboard_check_pressed(vk_up)||keyboard_check(ord("S"))
	key_down_pressed = keyboard_check_pressed(vk_down)||keyboard_check(ord("W"))
	key_jump = keyboard_check(vk_space) or keyboard_check(ord("Z"))

	if keyboard_check_pressed(ord("R"))
		room_restart()

	if keyboard_check_pressed(ord("Q"))
		room_speed = scr_approach(room_speed, rm_sp_min, 10)
	
	if keyboard_check_pressed(ord("E"))
		room_speed = scr_approach(room_speed, rm_sp_max, 10)
}
