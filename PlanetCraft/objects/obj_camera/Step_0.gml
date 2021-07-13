
if instance_exists(target) {
	var angle = aim_angle()
	var dist = sqrt(aim_dist())
	xto = target.x + lengthdir_x(dist, angle) * radius_fracture
	yto = target.y + lengthdir_y(dist, angle) * radius_fracture
	x = approach(x, xto, abs(x - xto)*sp_ratio)
	y = approach(y, yto, abs(y - yto)*sp_ratio)
}

scr_camera_set_pos(0, x, y)
