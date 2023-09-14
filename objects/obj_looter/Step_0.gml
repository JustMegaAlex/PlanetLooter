
if not global.game_over {
	key_left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	key_right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	key_up = keyboard_check(ord("W")) or keyboard_check(vk_up)
	key_down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	key_interact = keyboard_check_pressed(ord("E"))
	key_interact_hold = keyboard_check(ord("E"))
	key_create_module = keyboard_check_pressed(ord("Q"))
	key_shoot = mouse_check_button(mb_left)
	key_full_thrust = mouse_check_button(mb_right)
	key_warp = keyboard_check(vk_space)
	key_cruise = keyboard_check(ord("F"))
	key_cruise_off = keyboard_check_pressed(ord("F"))
	key_switch_forward = keyboard_check_pressed(ord("C")) or mouse_wheel_up()
	key_switch_back = keyboard_check_pressed(ord("X")) or mouse_wheel_down()
	key_repair = keyboard_check_pressed(ord("R"))
} else {
	key_left = false
	key_right = false
	key_up = false
	key_down = false
	key_interact = false
	key_shoot = false
	key_full_thrust = false
}

set_dir_to(point_dir(mouse_x, mouse_y))
if (in_cruise_mode < 1) and !full_thrust_sp and !global.game_over
	update_dir()
	
var is_igninte_full_thrust = key_full_thrust and (tank > 0)

if key_full_thrust and !full_thrust_sp {
	full_thrust_sp = max(full_thrust_acc, velocity.len())
}
if full_thrust_sp > 0 {
	full_thrust_sp = approach(full_thrust_sp,
							   full_thrust_sp_max * is_igninte_full_thrust,
							   full_thrust_acc)
	var _rot_factor = full_thrust_sp / full_thrust_sp_max
	var _rot_sp = _rot_factor * full_thrust_rotary_sp
				 + (1 - _rot_factor) * rotary_sp
	update_dir(_rot_sp)
	velocity.set_polar(full_thrust_sp, dir)
	if !is_igninte_full_thrust and (full_thrust_sp < sp.normal) {
		velocity.set_polar(full_thrust_sp, dir)
		full_thrust_sp = 0
	}
	self.spend_resource("fuel", full_thrust_consumption)
	obj_effects.thrust_effect(xprev, yprev, x, y)
}

// repair
if key_repair
	try_repair()

// create module ui
if key_create_module {
	if create_module_ui_inst {
		instance_destroy(create_module_ui_inst)
		global.ui_interface_on = false
	}
	else {
		create_module_ui_inst = instance_create_layer(x, y, "ui", obj_ui_create_module_menu)
		create_module_ui_inst.parent = id
		global.ui_interface_on = true
	}
}

// weapon switch
if key_switch_forward
	switch_weapon(1)
if key_switch_back
	switch_weapon(-1)
// switch via numbuttons
if keyboard_check_pressed(vk_anykey) 
		and keyboard_lastkey == clamp(keyboard_lastkey, ord("1"), ord("9")) {
	activate_weapon(keyboard_lastkey - ord("1"))
}

// warping
if warping {
	if audio_sound_get_track_position(warp_sound) > 1.9
			and spend_resource("fuel", warp_fuel_cost) {
		global.level++
		// restart room
		alarm[1] = 1
		warping = false
	} else if !key_warp {
		warping = false
		audio_stop_sound(snd_warp)
		warp_sound = noone
	}

} else if key_warp and (tank_load > warp_fuel_cost) {
	warping = true
	warp_sound = audio_play_sound(snd_warp, 0, false)
}

if (not --fuel_producer_pause) 
		and (tank_load < fuel_producer_treshold) {
	Resources.try_add("fuel", fuel_producer_ratio)
}

up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block)
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

//// movement
input_h = key_right - key_left
input_v = key_down - key_up
move_h = key_right * right_free - key_left * left_free
move_v = key_down * down_free - key_up * up_free
var input = (abs(move_h) or abs(move_v))

// cruise mode
if in_cruise_mode >= 1 {
	cruise_dir_to = inst_mouse_dir(id)
	var angle = angle_difference(cruise_dir_to, dir)
	if abs(angle) <= cruise_rot_sp
		dir = cruise_dir_to
	else
		dir += cruise_rot_sp * sign(angle)	
	cruise_sp = approach(cruise_sp, sp.cruise, cruise_acc)
	velocity.set_polar(cruise_sp, dir)
	if !spend_resource("fuel", sp.consumption) or key_cruise_off
		in_cruise_mode = 0
	obj_effects.thrust_effect(xprev, yprev, x, y)
	
} else if !full_thrust_sp {
	in_cruise_mode = (in_cruise_mode + cruise_switch_sp) * key_cruise
	if input {
		input_dir = point_direction(0, 0, move_h, move_v)
		velocity_to.set_polar(sp.normal, input_dir)
		velocity.approach(velocity_to, acceleration)
	} else {
		velocity.approach(global.zero2d, deceleration)
	}
}

if (velocity.X > 0) and !right_free or (velocity.X < 0) and !left_free
	//hsp = 0
	velocity.X = 0
if (velocity.Y > 0) and !down_free or (velocity.Y < 0) and !up_free
	//vsp = 0
	velocity.Y = 0

//// shooting
reloading--
if key_shoot 
		and !reloading 
		and !global.ui_interface_on 
		and (in_cruise_mode < 1) 
		and !create_module_ui_inst {
	looter_shoot(dir)
}

//// interacting
var with_ui = instance_place(x, y, obj_with_ui)
if !global.ui_interface_on {
	if with_ui {
		current_ui_source = with_ui
		with_ui.show_prompt()
		if key_interact {
			with_ui.UI.on_press_interact()
		}
		if key_interact_hold {
			with_ui.UI.on_hold_interact()	
		}
	}
} else {
	if key_interact and current_ui_source != noone {
		current_ui_source.UI.turn_off()
	}
}

xprev = x
yprev = y

if scr_move_coord_contact_obj(velocity.X, velocity.Y, obj_block)
	in_cruise_mode = 0
