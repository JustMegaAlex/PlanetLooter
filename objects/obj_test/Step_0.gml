
if keyboard_check_pressed(ord("G")) {
	var p = new Vec2d(mouse_x, mouse_y)
	array_push(links, p)
	if array_length(links) > 5 {
		array_delete(links, 0, 1)
	}
	astar.add_node_from_point(p, links)
}
	
