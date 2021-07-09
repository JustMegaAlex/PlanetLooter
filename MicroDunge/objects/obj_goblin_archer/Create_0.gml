
event_inherited()

function step_event() {
	move_v = 0
	move_h = 0
	var move_v_temp = 0
	var move_h_temp = 0
	var di = obj_knight.i - i
	var dj = obj_knight.j - j
	if (di == 0) or (dj == 0) {
		self.shoot(di, dj)
		pass_turn()
		return 0
	}
	if di >= dj {
		move_v = sign(dj)
		move_h_temp = sign(di)
	} else {
		move_h = sign(di)
		move_v_temp = sign(dj)
	}
	if try_move() {
		pass_turn()
		return 0
	}
	move_h = move_h_temp
	move_v = move_v_temp
	try_move()
	pass_turn()
}

function shoot(hdir, vdir) {
	with instance_create_layer(gridx(i), gridy(j), layer, obj_arrow) {
		self.hdir = hdir
		self.vdir = vdir
	}
}

dist_to_player = -1
move_h = 0
move_v = 0

hp = 2
