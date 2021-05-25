
event_inherited()

enum States {
	walk,
	fly,
	dash,
	timeshift,
	onwall,
	chaindash,
}

function dash() {
	dashing = dashtime
	dashdir = dirsign
	vsp = 0
	hsp = dashsp * dirsign
	state = States.dash
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

state = States.walk

jumps_max = 1
jumps = jumps_max
jump_press_delay = 15
jump_pressed = 0
on_ground_delay = 10
platform_obj = noone
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
