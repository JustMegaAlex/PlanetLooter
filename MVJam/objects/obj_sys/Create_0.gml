
scr_debug_INI()

mouse_pressed = false

draw_set_valign(fa_middle)
draw_set_halign(fa_center)

// settle up main room
if room == rm_main {
	
	room_ind = 1
	
	var but_x = scr_camw(0) * 0.5
	
	var but_y_st = 40
	
	var y_delta = sprite_get_height(spr_ui_button) + 30
	
	while room_exists(room_ind) {
		
		var btn = instance_create_layer(but_x, but_y_st + y_delta*room_ind, "Instances", obj_ui_button)
			
		btn.room_to_start = room_ind
		
		room_ind++
	}
}