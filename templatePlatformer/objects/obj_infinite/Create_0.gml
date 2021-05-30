
function chance(p) {
	return random(1) < p
}

fly_gap_vert = 30
fly_gap_hor = 60
displ = -30
block_w = sprite_get_width(spr_block)
block_h = sprite_get_height(spr_block)

function build_block(type) {
	if type == "random" {
		type = "horizontal"
		if chance(0.5) { type = "vertical" }
	}
	if type == "vertical" {
		// build vertically
		var xx = x + fly_gap_hor * input_move_h - block_w * (input_move_h < 0)
		var yy = y + displ
		instance_create_layer(xx, yy, layer, obj_block_v)
	} else {
		// build horizontally
		var xx = x + displ * input_move_h - block_w * (input_move_h < 0)
		var yy = y + fly_gap_vert
		instance_create_layer(xx, yy, layer, obj_block)
	}
}


/// main parameters
hsp_max = 4
hsp_inp = 0
vsp_max = 5
acc = 1.1
grav = 0.8
jump_sp = -12
hsp_to = 0	// how sp_x and sp_y change
hsp = 0
vsp = 0
dir = 0
move_h = 0
input_move_h = 1

rm_sp_min = 5
rm_sp_max = 60

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

flying_time_min = 10
flying_time_max = 60
flying = 0
key_right = false
key_left = false
key_jump = false
key_dash = false
