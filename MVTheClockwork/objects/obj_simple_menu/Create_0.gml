

button_obj = obj_menu_button
// settle up rooms buttons
room_ind = 0
room_count = 0
var but_x = scr_camw(0) * 0.5
var but_y_st = 40
var y_delta = sprite_get_height(object_get_sprite(button_obj)) + 30
while room_exists(room_ind) {
	if room_ind == room {
		room_ind++
		continue
	}
	room_count++
	var btn = instance_create_layer(but_x, but_y_st + y_delta*room_ind, "Instances", button_obj)
	btn.room_to_start = room_ind
	room_ind++
}

// if only one room start immidiately
if room_count == 1
	room_goto(1)


instr = "Controls:\n"
instr += "moving -- arrows\n"
instr += "Z or space -- jump\n"
instr += "X -- attack\n"
instr += "C -- dash\n"
instr += "D -- grapple\n"
instr += "R -- restart the room\n"
instr += "esc -- go back here\n"
instr += "E and Q -- increase/decrease game speed\n"
instr += "(donnow why you need this)\n"
instr += "If the game hangs relaunch\n"
instr += "Happy testing!\n"
