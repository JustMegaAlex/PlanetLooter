
function aim_dist() {
	return point_distance(scr_camx_cent(0), scr_camy_cent(0), mouse_x, mouse_y)
}

function aim_angle() {
	return point_direction(scr_camx_cent(0), scr_camy_cent(0), mouse_x, mouse_y)
}

anchor_radius_gain = 3
target = noone
sp_ratio = 0.125
rel_xto = x
rel_yto = y
relx = 0
rely = 0
