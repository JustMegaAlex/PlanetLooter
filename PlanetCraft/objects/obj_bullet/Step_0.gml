
life_distance -= weapon.sp
if not life_distance
	instance_destroy()

xprev = x
yprev = y
scr_move(weapon.sp, image_angle)
var inst = instance_place(x, y, obj_solid)
if inst and inst.side != side {
	inst.set_hit(weapon)
	obj_effects.explosion(x, y)
	instance_destroy()
	// knockback
	if inst.is_moving_object {
		var knock_back_force = weapon.knock_back_force
		var snd_id = choose(snd_hit, snd_hit1, snd_hit2, snd_hit3)
		var snd = audio_play_sound(snd_id, 0, false)
		audio_sound_gain(snd, 0.15, 0)
		// spark effect
		var coll_p = instance_line_collision_point(x, y, xprev, yprev, inst)
		var angle = point_direction(inst.x, inst.y, coll_p.x_, coll_p.y_)
		obj_effects.spark(x, y, angle, 10)
		// knockback
		inst.hsp += lengthdir_x(knock_back_force, image_angle)
		inst.vsp += lengthdir_y(knock_back_force, image_angle)
	}
}
