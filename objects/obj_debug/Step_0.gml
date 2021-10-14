
var num = instance_number(obj_planet)

if global.enable_instant_planet_move {
	if keyboard_check_pressed(ord("O")) {
		current_planet = cycle_increase(current_planet, 0, num)
		move_to_planet(current_planet)
	}
	if keyboard_check_pressed(ord("P")) {
		current_planet = cycle_increase(current_planet, 0, num)
		move_to_planet(current_planet)
	}
}

if global.enable_change_fps {
	if keyboard_check(vk_rshift) {
		if keyboard_check_pressed(vk_add)
			room_speed += 20
		else if keyboard_check_pressed(vk_subtract)
			room_speed -= 20
		room_speed = clamp(room_speed, 5, 1000)
	}
}

if keyboard_check_pressed(ord("E"))
	state = "editor"

switch state {
	case "editor": {
		if mouse_check_button_pressed(mb_left) {
			if editor_current_object != noone {
				instance_create_layer(mouse_x, mouse_y, "Instances", editor_current_object)
			}
		}
		mouse_over = instance_place(mouse_x, mouse_y, obj_gui_toggle_button)
		break
	}
}