
for (var i = 0; i < array_length(move_route); ++i) {
	var p = move_route[i]
    scr_debug_show_var("route " + string(i), string({X:p.X, Y:p.Y}))
}

scr_debug_show_var("mx", mouse_x)
scr_debug_show_var("my", mouse_y)
