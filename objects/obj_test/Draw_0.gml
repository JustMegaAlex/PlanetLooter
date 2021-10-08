
draw_self()

for (var i = 0; i < array_length(route) - 1; ++i) {
    var p = route[i]
	var p1 = route[i + 1]
	draw_line_color(p.X, p.Y, p1.X, p1.Y, c_yellow, c_yellow)
}
