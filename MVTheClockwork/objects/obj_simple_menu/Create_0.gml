

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
	room_goto(room_ind)
