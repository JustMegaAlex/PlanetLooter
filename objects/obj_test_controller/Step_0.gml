
if mouse_check_button_pressed(mb_left) {
	start = new Vec2d(mouse_x, mouse_y)
	graph.clear_all_scores()
	path = astar_find_path(start, finish)
}

if mouse_check_button_pressed(mb_right) {
	finish = new Vec2d(mouse_x, mouse_y)
	graph.clear_all_scores()
	path = astar_find_path(start, finish)
}
