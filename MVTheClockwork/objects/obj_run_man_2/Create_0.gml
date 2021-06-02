
event_inherited()

enum States {
	walk,
	fly,
	dash,
	timeshift,
	onwall,
	chaindash,
	being_hit,
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
	// stop on wall
	hsp = hsp * ((hsp > 0 and right_free) or (hsp < 0 and left_free))
	state = States.dash
	on_platform = noone
}

function chain() {
	chain_attached_to = chain_target
	var dir = point_direction(x, y, chain_attached_to.x ,chain_attached_to.y)
	hsp = lengthdir_x(chain_dash_sp, dir)
	vsp = lengthdir_y(chain_dash_sp, dir)
	state = States.chaindash
}

function get_chain_target() {
	var min_len = chain_max_len
	var target = noone
	for (var i = 0; i < instance_number(obj_chain_ring); i++) {
		var ring = instance_find(obj_chain_ring, i)
		// check player looks in right direction
		if !(sign(ring.x - x) == dirsign) continue
		var dist = point_distance(x, y, ring.x, ring.y)
		if (dist < min_len) {
			min_len = dist
			target = ring
		}
	}
	return target
}

function set_hit() {
	being_hit = after_hit_delay
	state = States.being_hit
}

function melee() {
	if swing_attack_pause
		return false
	instance_create_depth(x, y, depth - 1, obj_swing_attack)
	swing_attack_pause = swing_attack_delay
	return true
}

state = States.walk
last_platform_left = false
last_platform_right = false
moving_collider = noone
on_platform = false
last_on_platform = false
collider_hsp = 0
collider_vsp = 0
is_colliding = false

// shooting
bullet_number = 8

//// collisions
right_free = true
left_free = true
down_free = true
up_free = true

/// main parameters
hsp_max_base = 10
hsp_max = hsp_max_base
vsp_max = 15
acc = 5
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

// chain gun
chain_attached_to = noone
chain_target = noone
chain_dash_sp = 30
chain_min_len = 15
chain_max_len = 400

after_hit_delay = 40
being_hit = 0
attacker = noone


swing_attack_pause = 0
swing_attack_delay = 15
