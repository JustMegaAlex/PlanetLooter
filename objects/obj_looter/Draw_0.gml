
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)

// draw compass
for (var i = 0; i < instance_number(obj_planet); ++i) {
	var p = instance_find(obj_planet, i)
	var dist = point_distance(x, y, p.x, p.y)
	if dist < compas_min_dist
		continue
	var _dir = point_direction(x, y, p.x, p.y)
	var x0 = x + lengthdir_x(compas_r, _dir)
	var y0 = y + lengthdir_y(compas_r, _dir)
	var scale = (12000 - dist) / 2000  + 2000/dist
	scale = max(scale, 0.5)
	draw_sprite_ext(spr_arrow, 0, x0, y0, scale, 1, _dir, c_white, 0.25)
}

// test 
var res = collision_line_width(x, y, mouse_x, mouse_y, obj_planet_mask, 20)
if res.inst {
	draw_circle(res.inst.x, res.inst.y, 5, false)
	draw_line(res.x1, res.y1, res.x0, res.y0)
	draw_line(res.x3, res.y3, res.x2, res.y2)
}
