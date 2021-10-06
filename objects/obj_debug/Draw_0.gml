
if editor_current_object != noone
	draw_sprite(object_get_sprite(editor_current_object), 0, mouse_x, mouse_y)

if show_ai_patrol_routes {
	for (var j = 0; j < array_length(global.arr_patrol_routes); ++j) {
	    var _patrol_route = global.arr_patrol_routes[j]
		var arr_len = array_length(_patrol_route)
		// draw first-last line
		var pl0 = _patrol_route[0]
		var pl1 = _patrol_route[arr_len - 1]
		draw_line(pl0.x, pl0.y, pl1.x, pl1.y)
		for (var i = 0; i < arr_len - 1; ++i) {
		    pl0 = _patrol_route[i]
			pl1 = _patrol_route[i + 1]
			draw_line(pl0.x, pl0.y, pl1.x, pl1.y)
		}
	}
}
