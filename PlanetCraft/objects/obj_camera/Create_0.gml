
function aim_dist() {
	return point_distance(scr_camx_cent(0), scr_camy_cent(0), mouse_x, mouse_y)
}

function aim_angle() {
	return point_direction(scr_camx_cent(0), scr_camy_cent(0), mouse_x, mouse_y)
}

radius_fracture = 3
target = noone
sp_ratio = 0.125
xto = x
yto = y
