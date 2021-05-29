
l2.setend(mouse_x, mouse_y)
m = line_intersection(l2, l1, true)
if m != 0 l2.mult(m)
if keyboard_check_pressed(vk_space) {
	m = line_intersection(l2, l1, true)
	if m l2.mult(m)
}
