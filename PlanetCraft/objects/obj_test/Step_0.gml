
if keyboard_check_pressed(vk_left)
	val = cycle_change(val, -change, min_, max_)
if keyboard_check_pressed(vk_right)
	val = cycle_change(val, change, min_, max_)
if keyboard_check_pressed(vk_up)
	if keyboard_check(vk_shift)
		min_++
	else if keyboard_check(vk_control)
		change++
	else
		max_++
if keyboard_check_pressed(vk_down)
	if keyboard_check(vk_shift)
		min_--
	else if keyboard_check(vk_control)
		change--
	else
		max_--
