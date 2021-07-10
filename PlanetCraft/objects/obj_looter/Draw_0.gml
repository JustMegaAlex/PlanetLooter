
draw_self()

for (var i = 0; i < instance_number(obj_planet); ++i) {
    var p = instance_find(obj_planet, i)
	draw_line(x, y, p.x, p.y)
}
