
function scr_get_dir_to_point(x_, y_) {
	return point_direction(x, y, x_, y_)
}

function scr_move(speed, dir) {
	x += lengthdir_x(speed, dir)
	y += lengthdir_y(speed, dir)
}

function scr_move_contact(hsp, vsp) {
	x += hsp
	y += vsp
	if self.check_collision(x, y, obj_bound) {
		var dir = point_direction(0, 0, hsp, vsp)
		while self.check_collision(x, y, obj_bound) {
	        x -= lengthdir_x(1, dir);
	        y -= lengthdir_y(1, dir);
		}
		return true
	}
	return false
}
