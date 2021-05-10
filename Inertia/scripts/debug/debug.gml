/// updates variables of debug scripts
/// it's suggested to put this into some head object
/// in which scr_debug_show_var() is called

global.DEBUG_SHOW = false

function scr_debug_scripts_update() {
	global.VAR_BAR_LENGTH = 0
	global.VAR_BAR_X = 30
	global.VAR_BAR_Y = 30
}

function scr_debug_show_grid(grid, x0, y0) {
	if not global.DEBUG_SHOW { return }
	var i, j
	for(i=0;i<ds_grid_width(grid); i+=1) {
	    for(j=0; j<ds_grid_height(grid); j+=1) {
	        draw_text(x0 + 50 * i, y0 + 20 * j, string(ds_grid_get(grid, i, j)))
	    }
	}
}

function scr_debug_show_list(list, x0, y0) {
	if not global.DEBUG_SHOW { return }
	var i
	for(i=0; i<ds_list_size(list); i+=1) {
	    draw_text(x0, y0 + 20*i, string(ds_list_find_value(list, i)))
	}
}

function scr_debug_ini() {
	global.VAR_BAR_LENGTH = 0
	global.VAR_BAR_X = 0
	global.VAR_BAR_Y = 0
	global.VAR_BAR_ROW_DELTA = 20
}

function scr_debug_show_var(text, var_) {
	if not global.DEBUG_SHOW { return }
	global.VAR_BAR_LENGTH += 1;
	draw_text(global.VAR_BAR_X,
		global.VAR_BAR_Y+global.VAR_BAR_LENGTH*global.VAR_BAR_ROW_DELTA,
		object_get_name(object_index) + ": " + text+" "+string(var_)
	)
}
