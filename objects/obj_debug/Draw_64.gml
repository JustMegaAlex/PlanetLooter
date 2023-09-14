
if keyboard_key
	last_key = keyboard_key

show("last_key", last_key)
show("keyboard_lastkey", keyboard_lastkey)


if global.enable_change_fps
	scr_debug_show_var("fps", room_speed)