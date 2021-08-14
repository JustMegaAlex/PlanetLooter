
if not --spawn_timer {
	spawn_timer = 2
	obj_effects.explosion_small(x + random_range(-4, 4), y + random_range(-4, 4), 0.5)
	if not --count_to_death
		instance_destroy()
}

image_angle += rot_sp
scr_move_contact_obj(sp, move_dir, obj_block)
