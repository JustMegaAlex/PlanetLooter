
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)
var p = move_route_point_to
if (p != -4) and (p != undefined) {
	var _text = string(point_dist(p.X, p.Y))
	_text += is_patrol ? " is patrol" : ""
	draw_text_above_me(_text)
}

//geom_draw_multiline(move_route, 5, c_navy)

if find_path_failed_point {
	var c = c_red
	draw_line_width_color(x, y, find_path_failed_point.X, find_path_failed_point.Y, 10, c, c)
}
