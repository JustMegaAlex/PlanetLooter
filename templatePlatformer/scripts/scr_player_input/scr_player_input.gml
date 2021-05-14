function scr_player_input() {

	// controls
	key_left = keyboard_check(vk_left)||keyboard_check(ord("A"))
	key_right = keyboard_check(vk_right)||keyboard_check(ord("D"))
	key_jump = keyboard_check_pressed(vk_space) or keyboard_check_pressed(ord("Z"))
	key_dash = keyboard_check_pressed(ord("C"))

	if keyboard_check_pressed(ord("R"))
		room_restart()

	if keyboard_check_pressed(ord("Q"))
		room_speed = scr_approach(room_speed, rm_sp_min, 10)
	
	if keyboard_check_pressed(ord("E"))
		room_speed = scr_approach(room_speed, rm_sp_max, 10)


}
