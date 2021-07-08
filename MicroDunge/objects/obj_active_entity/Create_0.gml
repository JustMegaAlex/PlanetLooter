
function quit_active_qeue() {
	global.turn_controller.remove_from_active_qeue(self)
	if global.turn_controller.active_qeue_empty()
		global.turn_controller.next_move()
}
