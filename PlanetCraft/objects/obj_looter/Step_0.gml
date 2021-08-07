
if not global.game_over {
	key_left = keyboard_check(ord("A")) or keyboard_check(vk_left)
	key_right = keyboard_check(ord("D")) or keyboard_check(vk_right)
	key_up = keyboard_check(ord("W")) or keyboard_check(vk_up)
	key_down = keyboard_check(ord("S")) or keyboard_check(vk_down)
	key_interact = keyboard_check_pressed(ord("E"))
	key_shoot = mouse_check_button(mb_left) or keyboard_check(vk_lcontrol)
	key_warp = keyboard_check(vk_space)
	key_cruise = keyboard_check(ord("F"))
	key_cruise_off = keyboard_check_pressed(ord("F"))
	key_switch_forward = keyboard_check_pressed(ord("C")) or mouse_wheel_up()
	key_switch_back = keyboard_check_pressed(ord("X")) or mouse_wheel_down()
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

// weapon switch
if key_switch_forward
	switch_weapon(1)
if key_switch_back
	switch_weapon(-1)

// warping
if warping {
	if audio_sound_get_track_position(warp_sound) > 1.9 {
		resources[$ "fuel"] -= warp_fuel_cost
		global.level++
		// restart room
		alarm[1] = 1
		warping = false
	} else if !key_warp {
		warping = false
		audio_stop_sound(snd_warp)
		warp_sound = noone
	}

} else if key_warp and (resources[$ "fuel"] >= 10) {
	warping = true
	warp_sound = audio_play_sound(snd_warp, 0, false)
}

if not --fuel_producer_pause {
	var cost_info_arr = global.ResourceCost.fuel
	self.exchange_resources("fuel", fuel_producer_ratio, cost_info_arr)
}


//// planets
if not current_planet {
	var planet = instance_nearest(x, y, obj_planet)
	var dist = point_distance(x, y, planet.x, planet.y)
	if dist <= gravity_dist
		current_planet = planet
} else {
	// define gravity direction
	var dx = current_planet.x - x
	var dy = current_planet.y - y
	gravx = 0
	gravy = 0
	if abs(dx) > abs(dy) {
		gravx = grav * sign(dx)
	} else {
		gravy = grav * sign(dy)
	}
	var dist = point_distance(x, y, current_planet.x, current_planet.y)
	if dist > gravity_dist {
		current_planet = noone
		gravx = 0
		gravy = 0
	}
	else if dist <= gravity_min_dist {
		gravx = 0
		gravy = 0
	}
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
var input = abs(move_h) or abs(move_v)


if in_cruise_mode >= 1 {
	cruise_dir_to = inst_mouse_dir(id)
	var angle = angle_difference(cruise_dir_to, dir)
	if abs(angle) <= cruise_rot_sp
		dir = cruise_dir_to
	else
		dir += cruise_rot_sp * sign(angle)	
	cruise_sp = approach(cruise_sp, sp.cruise, cruise_acc)
	// input_h = 0 and hsp < 0 and gravx > 0
	hsp = lengthdir_x(cruise_sp, dir)
	vsp = lengthdir_y(cruise_sp, dir)
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
		self.set_sp_to(sp.normal, input_dir)
		hacc = abs(lengthdir_x(acc, input_dir))
		vacc = abs(lengthdir_y(acc, input_dir))
		// input_h = 0 and hsp < 0 and gravx > 0
		if abs(input_h) or !(sign(hsp) == sign(gravx))
			hsp = approach(hsp, hsp_to, acc)
		if abs(input_v) or !(sign(vsp) == sign(gravy))
			vsp = approach(vsp, vsp_to, acc)
	} else {
		if gravx == 0
			hsp = approach(hsp, 0, decel)
		if gravy == 0
			vsp = approach(vsp, 0, decel)
	}
}

hsp += gravx
vsp += gravy

if (hsp > 0) and !right_free or (hsp < 0) and !left_free
	hsp = 0
if (vsp > 0) and !down_free or (vsp < 0) and !up_free
	vsp = 0

//// shooting
reloading--
if key_shoot and !reloading and !global.ui_interface_on and (in_cruise_mode < 1) {
	shoot_dir = point_direction(x, y, mouse_x, mouse_y)
	shoot(shoot_dir, id, use_weapon, bullet_sp)
}

//// interacting
if key_interact {
	if global.ui_interface_on {
		instance_destroy(obj_building_ui)
		global.ui_interface_on = false
	} else {
		var building = instance_place(x, y, obj_building)
		if building
			building.interface()
	}
}

xprev = x
yprev = y

if scr_move_coord_contact_obj(hsp, vsp, obj_block)
	in_cruise_mode = 0
