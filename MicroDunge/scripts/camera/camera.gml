
function scr_camera_set_pos(id, x, y) {
	var cam = view_camera[id]
	camera_set_view_pos(cam,
						x-camera_get_view_width(cam)*0.5,
						y-camera_get_view_height(cam)*0.5)
}

function scr_camw(ind) {
	return camera_get_view_width(view_camera[ind])
}

function scr_camh(ind) {
	return camera_get_view_height(view_camera[ind])
}

function scr_camx(ind) {
	return camera_get_view_x(view_camera[ind])
}

function scr_camy(ind) {
	return camera_get_view_y(view_camera[ind])
}
