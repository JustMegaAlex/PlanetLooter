
enum States {
	walk,
	fly,
	dash,
	onwall,
}


function move_contact(hsp, vsp) {
	x += hsp
	y += vsp
	//collision
	var contact = instance_place(x, y, obj_block)
	if contact  {
		is_colliding = true
		// compute relative movement
		var relhsp = hsp - contact.hsp
		var relvsp = vsp - contact.vsp
		var reldir = point_direction(0, 0, relhsp, relvsp)
		// move out of an object coordinate-wise
		while true {
	        x -= lengthdir_x(1, reldir)
			// side collision
			if not place_meeting(x, y, contact) {
				if contact.object_index == obj_platform {
					last_platform_left = hsp < 0
					last_platform_right = hsp > 0
					moving_collider = contact
				}
				return contact
			}
			// vertical collision
	        y -= lengthdir_y(1, reldir)
			if not place_meeting(x, y, contact) {
				if (vsp > 0) and( contact.object_index == obj_platform) {
					moving_collider = contact
					// transition to on_platform state
					last_on_platform = true
				}
				return contact
			}
		}
	}
}


function dash() {
	if dashcooldown
		return false
	dashing = dashtime
	dashdir = dirsign
	vsp = 0
	hsp = dashsp * dirsign
	// stop on wall
	hsp = hsp * ((hsp > 0 and right_free) or (hsp < 0 and left_free))
	state = States.dash
	on_platform = noone
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

function resolve_collision(obj) {
	point = self.point_in_object(obj)
	while point {
		self.perform_collision_solving(point, obj);
		point = self.point_in_object(obj)
	}
}

function perform_collision_solving(point, obj) {
	// make reversed speed vector
	var relhsp
	if obj.object_index == obj_block
		// don't count hsp as relative if being pushed by a platform
		// while colliding with another object
		relhsp = (hsp - obj.hsp) * (right_free and left_free)
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
		state = States.walk
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



state = States.walk
last_platform_left = false
last_platform_right = false
moving_collider = noone
on_platform = false
last_on_platform = false
collider_hsp = 0
collider_vsp = 0

//// collisions
right_free = true
left_free = true
down_free = true
up_free = true

/// main parameters
hsp_max_base = 3
hsp_max = hsp_max_base
vsp_max = 5
acc = 5
grav = 0.8
jump_sp = -6
hsp_to = 0	// how sp_x and sp_y change
hsp = 0
vsp = 0
dir = 0
move_h = 0

rm_sp_min = 5
rm_sp_max = 60

draw_set_color(c_black)

jumps_max = 1
jumps = jumps_max
jump_press_delay = 15
jump_pressed = 0
on_ground_delay = 10
on_ground = 0 // used to fake ground for smoother jumping
on_wall = false
dirsign = 1
dashtime = 5
dashsp = 15
dashing = false
dashcooldown = 0
dashcooldowntime = 20
