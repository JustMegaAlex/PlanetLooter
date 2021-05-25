
enum States {
	walk,
	fly,
	dash,
	timeshift,
	onwall,
}

enum MovingCollisions {
	none,
	left_to,
	right_to,
	left_from,
	right_from,
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

function shoot() {
	repeat(bullet_number)
		instance_create_layer(x, y, layer, obj_chain_bullet)
}

function dash() {
	if dashcooldown
		return false
	dashing = dashtime
	dashdir = dirsign
	vsp = 0
	hsp = dashsp * dirsign
	state = States.dash
}


state = States.walk
moving_collision = MovingCollisions.none
last_platform_left = false
last_platform_right = false
moving_collider = noone
on_platform = false
last_on_platform = false
collider_hsp = 0
collider_vsp = 0
is_colliding = false
hsp_restricted_by_collision = false

// shooting
bullet_number = 8

/// main parameters
hsp_max_base = 10
hsp_max = hsp_max_base
hsp_inp = 0
vsp_max = 15
acc = 3
grav = 0.8
jump_sp = -18
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
dashsp = 45
dashing = false
dashcooldown = 0
dashcooldowntime = 20
timeshiftammount = 180
timeshift_sp = -2
