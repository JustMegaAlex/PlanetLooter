

function step_event() {
	// define in child objects
}

function init_move() {
	// define in child objects
}

function pass_turn() {
	my_turn = false
	global.turn_controller.next_move()
}

snap_to_grid(self)
i = gridi(x)
j = gridj(y)
my_turn = false
move_finished = false
