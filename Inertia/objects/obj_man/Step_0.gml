
input_left = keyboard_check(vk_left) or keyboard_check(ord("J"))
input_right = keyboard_check(vk_right) or keyboard_check(ord("L"))
input_up = keyboard_check(vk_up) or keyboard_check(ord("I"))
input_down = keyboard_check(vk_down) or keyboard_check(ord("K"))
input_shoot = keyboard_check_pressed(ord("Z"))

up_free = place_empty(x, y - 1, obj_bound)
down_free = place_empty(x, y + 1, obj_bound)
left_free = place_empty(x - 1, y, obj_bound)
right_free = place_empty(x + 1, y, obj_bound)

input = input_left or input_right or input_down or input_up

if input {
	if not input_key {
		input_key = self.get_input()
		dir = get_dir(input_key)
		set_image_angle(dir)
	} else {
		second_input_key = self.get_input()
		if second_input_key
			image_angle = get_dir(second_input_key)
		// change move dir if current move button is released
		if not keyboard_check(input_key) {
			input_key = second_input_key
			dir = image_angle
		}
	}
} else {
	input_key = -1
}

moveh = lengthdir_x(input, dir)
movev = lengthdir_y(input, dir)

if input {
	hsp = scr_approach(hsp, spmax * moveh, acc) 
	vsp = scr_approach(vsp, spmax * movev, acc)
} else {
	hsp = scr_approach(hsp, 0, decel) 
	vsp = scr_approach(vsp, 0, decel)
}

// stop by walls
hsp *= sign(hsp) == 1 and right_free or sign(hsp) == -1 and left_free
vsp *= sign(vsp) == 1 and down_free or sign(vsp) == -1 and up_free

if input_shoot and not reloading and stamina > 0 {
	with instance_create_layer(x, y, layer, obj_photon) {
		image_angle = other.image_angle
		side = other.side
	}
	reloading = reload_time
	stamina--
}
reloading--

// punch
var sp = max(abs(hsp), abs(vsp))
if sp == spmax {
	var enemy = instance_place(x, y, obj_collide)
	if enemy {
		enemy.set_hit()
		enemy.set_dir(image_angle)
		enemy.set_sp(sp)
		enemy.state = States.stop
		sp = 0.25 * spmax
		hsp = lengthdir_x(sp, dir)
		vsp = lengthdir_y(sp, dir)
	}
}

scr_camera_set_pos(0, x, y)

scr_move_contact(hsp, vsp)
