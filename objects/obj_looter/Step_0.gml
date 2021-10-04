
if not global.game_over {
	key_left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	key_right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	key_up = keyboard_check(ord("W")) or keyboard_check(vk_up)
	key_down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	key_interact = keyboard_check_pressed(ord("E"))
	key_create_module = keyboard_check_pressed(ord("Q"))
	key_shoot = mouse_check_button(mb_left) or keyboard_check(vk_lcontrol)
	key_warp = keyboard_check(vk_space)
	key_cruise = keyboard_check(ord("F"))
	key_cruise_off = keyboard_check_pressed(ord("F"))
	key_switch_forward = keyboard_check_pressed(ord("C")) or mouse_wheel_up()
	key_switch_back = keyboard_check_pressed(ord("X")) or mouse_wheel_down()
	key_repair = keyboard_check_pressed(ord("R"))
	if in_cruise_mode < 1
		dir = point_direction(x, y, mouse_x, mouse_y)
} else {
	key_left = false
	key_right = false
	key_up = false
	key_down = false
	key_interact = false
	key_shoot = false
}

// repair
if key_repair
	try_repair()

// create module ui
if key_create_module and !global.ui_interface_on {
	if create_module_ui_inst {
		instance_destroy(create_module_ui_inst)
		global.ui_interface_on = false
	}
	else {
		create_module_ui_inst = instance_create_layer(x, y, layer, obj_ui_create_module_menu)
		create_module_ui_inst.parent = id
		global.ui_interface_on = true
	}
}

// weapon switch
if key_switch_forward
	switch_weapon(1)
if key_switch_back
	switch_weapon(-1)

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

if not --fuel_producer_pause {
	var cost_info = global.resource_types.fuel.cost
	self.exchange_resources("fuel", fuel_producer_ratio, cost_info)
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
var input = (abs(move_h) or abs(move_v)) * !create_module_ui_inst

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

	// jet effect
	var dist = point_distance(xprev, yprev, x, y)
	var xx, yy
	var step = obj_effects.part_jet_step_size
	var partnum = max(1, dist div step)
	for (var i = 0; i < partnum; ++i) {
	    xx = lerp(xprev, x, step * i / dist)
		yy = lerp(yprev, y, step * i / dist)
		obj_effects.jet_long(xx, yy)
	}
} else {
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
	shoot_dir = point_direction(x, y, mouse_x, mouse_y)
	looter_shoot(shoot_dir)
}

//// interacting
if key_interact {
	if global.ui_interface_on {
		instance_destroy(obj_building_ui)
		global.ui_interface_on = false
	} else {
		var building = instance_place(x, y, obj_with_ui)
		if building
			building.interface()
	}
}


xprev = x
yprev = y

if scr_move_coord_contact_obj(velocity.X, velocity.Y, obj_block)
	in_cruise_mode = 0
