
// solve collisions
var contact = instance_place(x, y, obj_block)
while contact {
	self.resolve_collision(contact)
	// check collision with another object
	var contact = instance_place(x, y, obj_block)
}

up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block)
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

scr_camera_set_center(0, x, y)

function resolve_collision(obj) {
	point = self.point_in_object(obj)
	while point {
		self.perform_collision_solving(point, obj);
		point = self.point_in_object(obj)
	}
}

function perform_collision_solving(point, obj) {
	// make reversed speed vector
	var move = new Line(point.x_, point.y_, point.x_ - hsp, point.y_ - vsp)
	//// check all bounds
	// get vector multiplier by intersection
	var tb = obj.top_bound()
	var bb = obj.bottom_bound()
	var rb = obj.right_bound()
	var lb = obj.left_bound()
	var m = line_intersection(move, obj.left_bound(), false);
	if (m >= 0) and (m <= 1) {
		// cut move vector
		move.mult(m)
		x += move.xend - move.xst - 1
		y += move.yend - move.yst
		return true
	}
	var m = line_intersection(move, obj.top_bound(), false);
	if (m >= 0) and (m <= 1) {
		move.mult(m)
		x += move.xend - move.xst
		y += move.yend - move.yst - 1
		return true
	}
	var m = line_intersection(move, obj.right_bound(), false);
	if (m >= 0) and (m <= 1) {
		move.mult(m)
		x += move.xend - move.xst + 1
		y += move.yend - move.yst
		return true
	}
	var bb = obj.bottom_bound()
	var m = line_intersection(move, obj.bottom_bound(), false);
	if (m >= 0) and (m <= 1) {
		move.mult(m)
		x += move.xend - move.xst
		y += move.yend - move.yst + 1
		return true
	}
	return false
}
