
graph.draw_graph()

draw_text(20, 20, string(array_length(path)))
draw_circle_color(start.X, start.Y, 6, c_blue, c_blue, false)
draw_circle_color(finish.X, finish.Y, 6, c_green, c_green, false)

for (var i = 0; i < array_length(path) - 1; ++i) {
    p = path[i]
	pp = path[i + 1]
	draw_line_color(p.X, p.Y, pp.X, pp.Y, c_yellow, c_yellow)
}
