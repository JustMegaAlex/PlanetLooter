function scr_player_input() {

	// controls
	key_left = keyboard_check(vk_left)
	key_right = keyboard_check(vk_right)
	key_jump = keyboard_check_pressed(vk_space) or keyboard_check_pressed(ord("Z"))
	key_jump_hold = keyboard_check(vk_space) or keyboard_check(ord("Z"))
	key_dash = keyboard_check_pressed(ord("C"))
	key_chain = keyboard_check_pressed(ord("D"))
	key_special = keyboard_check_pressed(ord("A"))
	key_attack = keyboard_check_pressed(ord("X"))
	key_shoot = keyboard_check_pressed(ord("S"))

	if keyboard_check_pressed(ord("R"))
		room_restart()

	if keyboard_check_pressed(ord("Q"))
		room_speed = scr_approach(room_speed, rm_sp_min, 10)
	
	if keyboard_check_pressed(ord("E"))
		room_speed = scr_approach(room_speed, rm_sp_max, 10)


}
