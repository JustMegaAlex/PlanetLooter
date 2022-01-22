
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)
draw_text_above_me(string(array_length(move_route)))
//geom_draw_multiline(move_route, 5, c_navy)

if find_path_failed_point {
	var c = c_red
	draw_line_width_color(x, y, find_path_failed_point.X, find_path_failed_point.Y, 10, c, c)
}

if harvest_point {
	var c = c_green
	draw_line_width_color(x, y, harvest_point.X, harvest_point.Y, 3, c, c)
}
