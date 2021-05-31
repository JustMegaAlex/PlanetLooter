
function resolve_collision(obj) {
	point = self.point_in_object(obj)
	while point {
		self.perform_collision_solving(point, obj);
		point = self.point_in_object(obj)
	}
}

function perform_collision_solving(point, obj) {
	if object_index == obj_agro
		test = true
	// make reversed speed vector
	var relhsp
	if obj.object_index == obj_block
		// don't count hsp as relative if being pushed by a platform
		// while colliding with another object
		relhsp = hsp - obj.hsp * (right_free and left_free)
	else
		relhsp = (hsp - obj.hsp)
	var relvsp = vsp - obj.vsp
	var move = new Line(point.x_, point.y_, point.x_ - relhsp, point.y_ - relvsp)
	//// check all bounds
	// get vector multiplier by intersection
	var m = line_intersection(move, obj.left_bound(), false);
	if (m >= 0) and (m <= 1) {
		// cut move vector
		move.mult(m)
		x += move.xend - move.xst - 1
		y += move.yend - move.yst
		collider_hsp = obj.hsp
		return true
	}
	var m = line_intersection(move, obj.top_bound(), false);
	if (m >= 0) and (m <= 1) {
		move.mult(m)
		x += move.xend - move.xst
		y += move.yend - move.yst - 1
		on_platform = obj
		return true
	}
	var m = line_intersection(move, obj.right_bound(), false);
	if (m >= 0) and (m <= 1) {
		move.mult(m)
		x += move.xend - move.xst + 1
		y += move.yend - move.yst
		collider_hsp = obj.hsp
		return true
	}
	var m = line_intersection(move, obj.bottom_bound(), false);
	if (m >= 0) and (m <= 1) {
		move.mult(m)
		x += move.xend - move.xst
		y += move.yend - move.yst + 1
		return true
	}
	return false
}

function point_in_object(obj) {
	var point = self.topleft()
	if collision_point(point.x_, point.y_, obj, false, true) { return point }
	point = self.topright()
	if collision_point(point.x_, point.y_, obj, false, true) { return point }
	point = self.bottomleft()
	if collision_point(point.x_, point.y_, obj, false, true) { return point }
	point = self.bottomright()
	if collision_point(point.x_, point.y_, obj, false, true) { return point }
}

function topleft() {
	return new Point(bbox_left, bbox_top)
}
function topright() {
	return new Point(bbox_right, bbox_top)
}
function bottomleft() {
	return new Point(bbox_left, bbox_bottom)
}
function bottomright() {
	return new Point(bbox_right, bbox_bottom)
}