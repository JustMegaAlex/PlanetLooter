
if !instance_exists(obj_looter)
	instance_destroy()

image_angle = obj_looter.dir
pos.set(obj_looter.x, obj_looter.y)

if (phase == -1) {
	if mouse_check_button_pressed(mb_right) {
		phase++
		sp = phase0_sp
		phase1_dist = min(hit_max_dist, point_distance(obj_looter.x, obj_looter.y, mouse_x, mouse_y))
		timer = phase0_time
		relsp = phase0_sp
	}
}

switch phase {
	case 0: {
		if !--timer {
			phase++
			phase1_time = phase1_dist / phase1_sp_mag
			timer = phase1_time
			// (hitpos - relpos).normalize(hit_sp)
			relsp = (new Vec2d(phase1_dist, 0)).sub(relpos).normalize(phase1_sp_mag)
		}
		relpos.add(relsp)
		break
	}
	case 1: {
		if !--timer
			phase++
		if timer < (phase1_time / 2) {
			var hitted = instance_place(x, y, obj_ship_entity)
			if hitted {
				hitted.set_hit(self.weapon)
				obj_effects.explosion(x, y)
			}	
		}
		relpos.add(relsp)
		break
	}
	case 2: {
		if !relpos.eq(relpos_initial) {
			relpos.move_to_vec(relpos_initial, phase2_sp_mag)
		} else {
			phase = -1	
		}
	}
}

pos.add(relpos.rotated(image_angle))

x = pos.X
y = pos.Y

with couple_instance {
	image_angle = obj_looter.dir
	var vec = other.relpos
	relpos.set(vec.X, -vec.Y)
	pos.set(obj_looter.x, obj_looter.y)
	pos.add(relpos.rotated(image_angle))
	x = pos.X
	y = pos.Y
}
