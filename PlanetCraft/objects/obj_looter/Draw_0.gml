
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)

for (var i = 0; i < instance_number(obj_planet); ++i) {
	var p = instance_find(obj_planet, i)
	var dist = point_distance(x, y, p.x, p.y)
	if dist < compas_min_dist
		continue
	var _dir = point_direction(x, y, p.x, p.y)
	var x0 = x + lengthdir_x(compas_r, _dir)
	var y0 = y + lengthdir_y(compas_r, _dir)
	var scale = 1 + 3600/dist
	draw_sprite_ext(spr_arrow, 0, x0, y0, scale, 1, _dir, c_white, 0.25)
}
