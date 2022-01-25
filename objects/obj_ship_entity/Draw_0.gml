
if global.ai_show_move_routes
	for (var i = 0; i < array_length(move_route) - 1; ++i) {
	    var p = move_route[i]
		var pp = move_route[i + 1]
		draw_line(p.X, p.Y, pp.X, pp.Y)
	}
