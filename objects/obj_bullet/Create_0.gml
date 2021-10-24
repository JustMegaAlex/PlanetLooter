
function bring_damage() {
	var inst = instance_place(x, y, obj_solid)
	if inst and inst.side != side {
		obj_effects.explosion(x, y)
		// knockback
		if inst.is_moving_object {
			var knock_back_force = weapon.knock_back_force
			var snd_id = choose(snd_hit, snd_hit1, snd_hit2, snd_hit3)
			var snd = audio_play_sound(snd_id, 0, false)
			audio_sound_gain(snd, 0.15, 0)
			// spark effect
			var coll_p = instance_line_collision_point(x, y, xprev, yprev, inst)
			var angle = point_direction(inst.x, inst.y, coll_p.X, coll_p.Y)
			obj_effects.spark(x, y, angle, 10)
			// knockback
			inst.hsp += lengthdir_x(knock_back_force, image_angle)
			inst.vsp += lengthdir_y(knock_back_force, image_angle)
		}
		inst.set_hit(weapon)
		instance_destroy()
	}
}

function move() {
	scr_move(sp, image_angle)
}

visible = false
image_speed = 0
alarm[0] = 1
sp = 10
life_distance = 300
side = -1
spawner = noone

xprev = x
yprev = y
