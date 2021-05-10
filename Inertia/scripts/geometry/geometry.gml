// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function line_intersection(x0, y0, x1, y1, obj){
	var tol = 1
	var step = point_distance(x0, y0, x1, y1)
	var angle = point_direction(x0, y0, x1, y1)
	if not collision_line(x0, y0, x1, y1, obj, false, true)
		return [x1, y1]
	while step > tol {
		step *= 0.5
		if collision_line(x0, y0, x1, y1, obj, false, true) {
			x1 -= lengthdir_x(step, angle)
			y1 -= lengthdir_y(step, angle)
		} else {
			x1 += lengthdir_x(step, angle)
			y1 += lengthdir_y(step, angle)
		}
	}
	return [x1, y1]
}