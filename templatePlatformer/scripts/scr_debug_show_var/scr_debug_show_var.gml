function scr_debug_show_var(argument0, argument1) {
	global.VAR_BAR_LENGTH += 1;
	draw_text(global.VAR_BAR_X,
		global.VAR_BAR_Y+global.VAR_BAR_LENGTH*global.VAR_BAR_ROW_DELTA,
		object_get_name(object_index) + ": " + argument0+" "+string(argument1));


}
