
event_inherited()

function step_event() {
	dist_to_player = dist_to(obj_knight)
	move_v = 0
	move_h = 0
	var move_v_temp = 0
	var move_h_temp = 0
	var di = obj_knight.i - i
	var dj = obj_knight.j - j
	if dist_to_player == 1 {
		attack(obj_knight)
		pass_turn()
		return 0
	}
	if abs(di) >= abs(dj) {
		move_h = sign(di)
		move_v_temp = sign(dj)
	} else {
		move_h_temp = sign(di)
		move_v = sign(dj)
	}
	// first try move
	if try_move() {
		pass_turn()
		return 0
	}
	// if blocked try another dir
	move_h = move_h_temp
	move_v = move_v_temp
	try_move()
	pass_turn()
}

dist_to_player = -1
move_h = 0
move_v = 0

hp = 2
