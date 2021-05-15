
mouse_pressed = mouse_check_button_pressed(mb_left)

if keyboard_check_pressed(vk_escape)
	room_goto(rm_main)

if global.timeshifting {
	global.timeshifting += global.timesp
	if not global.timeshifting
		global.timesp = global.timesp_base
}

global.time += global.timesp
