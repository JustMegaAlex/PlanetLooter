
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)

for (var i = 0; i < instance_number(obj_planet); ++i) {
    var p = instance_find(obj_planet, i)
	draw_line(x, y, p.x, p.y)
}
