
scr_debug_scripts_update()

if keyboard_check_pressed(ord("R")) {
	instance_destroy(obj_looter)
	level = 0
	room_restart()
}

if keyboard_check_pressed(ord("T"))
	show_tips = !show_tips
