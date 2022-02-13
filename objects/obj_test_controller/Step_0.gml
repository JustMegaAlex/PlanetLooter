
if mouse_check_button_pressed(mb_left) {
	start = new Vec2d(mouse_x, mouse_y)
	graph.clear_all_scores()
	path = graph.find_path_old(start, finish)
}

if mouse_check_button_pressed(mb_right) {
	finish = new Vec2d(mouse_x, mouse_y)
	graph.clear_all_scores()
	path = graph.find_path_old(start, finish)
}

if keyboard_check_pressed(ord("N"))
	graph.DebugDrawer.switch_iteration(1)
if keyboard_check_pressed(ord("B"))
	graph.DebugDrawer.switch_iteration(-1)
if keyboard_check_pressed(vk_escape)
	game_end()
