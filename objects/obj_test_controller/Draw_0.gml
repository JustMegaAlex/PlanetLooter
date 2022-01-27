
//graph.draw_graph()
var c = c_blue
draw_line_color(p0.X, p0.Y, p1.X, p1.Y, c, c)


draw_text(20, 20, string(array_length(path)))
draw_text(20, 40, string(p0.X) + " " + string(p0.Y) + " --- " + string(p1.X) + " " + string(p1.Y))
draw_circle_color(start.X, start.Y, 6, c_blue, c_blue, false)
draw_circle_color(finish.X, finish.Y, 6, c_green, c_green, false)

if path != global.AstarPathFindFailed {
	for (var i = 0; i < array_length(path) - 1; ++i) {
	    p = path[i]
		pp = path[i + 1]
		draw_line_color(p.X, p.Y, pp.X, pp.Y, c_yellow, c_yellow)
	}
}
