
event_inherited()

function set_sp_to(sp, dir) {
	hsp_to = lengthdir_x(sp, dir)
	vsp_to = lengthdir_y(sp, dir)
}

function set_dir_to(_dir_to) {
	dir_to = _dir_to
}

function update_dir() {
	_diff = angle_difference(dir, dir_to)
	dir = approach(dir, dir - _diff, rotary_sp)
}

// systems
hp = 7
weapon = {
	dmg: 1,
	mining: 1,
	reload_time: 10,
	consumption: 0.0,
	knock_back_force: 3.5
}

sp = {normal: 5, cruise: 15, consumption: 0.007}

position = new Vec2d(x, y)
velocity = new Vec2d(0, 0)
velocity_to = new Vec2d(0, 0)
acceleration = new Vec2d(0.5, 0.5)
deceleration = new Vec2d(0.2, 0.2)
is_moving_object = true
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.5
decel = 0.2
hacc = 0
vacc = 0
input_h = 0
input_v = 0
move_h = 0
move_v = 0
input_dir = 0
rotary_sp = 5
dir = 0
dir_to = 0