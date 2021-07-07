

function step_event() {
	// define in child objects
}

function init_move() {
	// define in child objects
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

snap_to_grid(self)
i = gridi(x)
j = gridj(y)
my_turn = false
move_finished = false
