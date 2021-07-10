
key_left = keyboard_check(ord("A")) or keyboard_check(vk_left)
key_right = keyboard_check(ord("D")) or keyboard_check(vk_right)
key_up = keyboard_check(ord("W")) or keyboard_check(vk_up)
key_down = keyboard_check(ord("S")) or keyboard_check(vk_down)
//key_shoot_left = keyboard_check(ord("A"))
//key_shoot_right = keyboard_check(ord("D"))
//key_shoot_up = keyboard_check(ord("W"))
//key_shoot_down = keyboard_check(ord("S"))
key_shoot = mouse_check_button(mb_left)

up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block)
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

//// movement
input_h = key_right - key_left
input_v = key_down - key_up
move_h = key_right * right_free - key_left * left_free
move_v = key_down * down_free - key_up * up_free
var input = abs(move_h) or abs(move_v)

if input {
	input_dir = point_direction(0, 0, move_h, move_v)
	hsp_to = lengthdir_x(sp, input_dir)
	vsp_to = lengthdir_y(sp, input_dir)
	hacc = abs(lengthdir_x(acc, input_dir))
	vacc = abs(lengthdir_y(acc, input_dir))
	hsp = approach(hsp, hsp_to, acc)
	vsp = approach(vsp, vsp_to, acc)
} else {
	hsp = approach(hsp, 0, decel)
	vsp = approach(vsp, 0, decel)
}

//// shooting
reloading--
//shoot_h = key_shoot_right - key_shoot_left
//shoot_v = key_shoot_down - key_shoot_up
//if (abs(shoot_h) or abs(shoot_v)) and !reloading {
if key_shoot and !reloading {
	shoot_dir = point_direction(x, y, mouse_x, mouse_y)
	shoot(shoot_dir)
}

scr_move_coord_contact_obj(hsp, vsp, obj_block)
scr_camera_set_pos(0, x, y)
