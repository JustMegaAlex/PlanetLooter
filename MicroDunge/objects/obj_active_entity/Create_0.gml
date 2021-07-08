

function step_event() {
	// define in child objects
	// performed on entity's turn
}

function init_move() {
	// define in child objects
	// performed on entity's turn start
}

function pass_turn() {
	my_turn = false
	move_finished = true
	global.turn_controller.next_move()
}

function move_to(ii, jj) {
	grid_move_to(ii, jj, self)
	i = ii
	j = jj
	x = gridx(i)
	y = gridy(j)
}

function dist_to(inst) {
	return grid_dist(i, j, inst.i, inst.j)
}

function try_move() {
	if abs(move_h) or abs(move_v) {
		var ii = i + move_h
		var jj = j + move_v
		if grid_at(ii, jj) == noone {
			move_to(ii, jj)
			return true
		}
	}
	return false
}

snap_to_grid(self)
i = gridi(x)
j = gridj(y)
grid_place_instance(self, i, j)
my_turn = false
move_finished = false
inactive = false
