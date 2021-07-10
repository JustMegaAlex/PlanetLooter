
key_left = keyboard_check(vk_left)
key_right = keyboard_check(vk_right)
key_up = keyboard_check(vk_up)
key_down = keyboard_check(vk_down)

move_h = key_right - key_left
move_v = key_down - key_up
var input = abs(move_h) or abs(move_v)

if input {
	input_dir = point_direction(0, 0, move_h, move_v)
	hsp_to = lengthdir_x(sp, input_dir)
	vsp_to = lengthdir_y(sp, input_dir)
	hacc = abs(lengthdir_x(acc, input_dir))
	vacc = abs(lengthdir_y(acc, input_dir))
	hsp = approach(hsp, hsp_to, hacc)
	vsp = approach(vsp, vsp_to, vacc)
} else {
	hsp = approach(hsp, 0, acc)
	vsp = approach(vsp, 0, acc)
}

scr_move_coord(hsp, vsp)
scr_camera_set_pos(0, x, y)
