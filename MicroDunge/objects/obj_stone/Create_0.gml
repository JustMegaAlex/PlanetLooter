
event_inherited()

function step_event() {
	if not timer--
		pass_turn()
}

function init_move() {
	timer = timer_time
}

timer_time = 30
timer = 0