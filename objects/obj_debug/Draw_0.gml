
if editor_current_object != noone
	draw_sprite(object_get_sprite(editor_current_object), 0, mouse_x, mouse_y)

if global.show_ai_patrol_routes {
	var c = c_green
	for (var j = 0; j < array_length(global.arr_patrol_routes); ++j) {
	    var _patrol_route = global.arr_patrol_routes[j]
		var arr_len = array_length(_patrol_route)
		// draw first-last line
		var pl0 = _patrol_route[0]
		var pl1 = _patrol_route[arr_len - 1]
		draw_line_width_color(pl0.X, pl0.Y, pl1.X, pl1.Y, 3, c, c)
		// draw all other lines
		for (var i = 0; i < arr_len - 1; ++i) {
		    pl0 = _patrol_route[i]
			pl1 = _patrol_route[i + 1]
			draw_line_width_color(pl0.X, pl0.Y, pl1.X, pl1.Y, 3, c, c)
			var line = new Line(pl0.X, pl0.Y, pl1.X, pl1.Y)
		}
	}
}

if global.show_path_finding_graph {
	global.astar_graph.draw_graph(c_green)
	//global.astar_graph_inner.draw_graph(c_green)
}

if global.debug_test_path_finding {
	testPathFinding.draw_event()
	draw_text(mouse_x, mouse_y - 40, string(mouse_x) + " " + string(mouse_y))
}
