
scr_debug_scripts_update()

global.time += delta_time

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

if keyboard_check_pressed(ord("`")) or keyboard_check_pressed(ord("R")) {
    if instance_exists(obj_debug_console) {
        if obj_debug_console.turned_on
            obj_debug_console.turn_off()
        else
            obj_debug_console.turn_on()
    }
}

if TEST_PATH_FIND {
	test_time -= delta_time / 1000000
	if !test_time
		room_restart()
}
