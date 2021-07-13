
if instance_exists(target) {
	var angle = aim_angle()
	var dist = sqrt(aim_dist()) * anchor_radius_gain
	rel_xto = lengthdir_x(dist, angle)
	rel_yto = lengthdir_y(dist, angle)
	var rel_hsp = abs(relx - rel_xto)*sp_ratio
	var rel_vsp = abs(rely - rel_yto)*sp_ratio
	relx = approach(relx, rel_xto, rel_hsp)
	rely = approach(rely, rel_yto, rel_vsp)
	x = target.x + relx
	y = target.y + rely
}

scr_camera_set_pos(0, x, y)
