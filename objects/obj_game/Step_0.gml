
scr_debug_scripts_update()

if keyboard_check_pressed(vk_f3) {
	instance_destroy(obj_looter)
	reset_globals()
	global.level = 0
	room_restart()
}

if keyboard_check_pressed(vk_escape)
	game_end()

if keyboard_check_pressed(vk_f11)
	window_set_fullscreen(!window_get_fullscreen())

if keyboard_check_pressed(ord("T"))
	show_tips = !show_tips

global.time += delta_time
