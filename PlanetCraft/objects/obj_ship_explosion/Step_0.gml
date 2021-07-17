
//switch phase {
//	case 0: {
//		repeat(3)
//			obj_effects.explosion(x + random_range(-12, 12), y + random_range(-12, 12))
//		phase++
//		counter = 5
//		sp = 8
//		move_dir = random(360)
//		break
//	}
//	case 1: {
//		if not --counter {
//			phase++	
//		}
//		break
//	}
//	case 2: {
//		repeat(4)
//			obj_effects.explosion(x + random_range(-12, 12), y + random_range(-12, 12))
//		phase++
//		counter = 5
//		sp = 8
//		move_dir = random(360)
//		break
//	}
//	case 3: {
//		if not --counter {
//			phase++	
//		}
//		break
//	}
//	case 4: {
//		repeat(4)
//			obj_effects.explosion(x + random_range(-12, 12), y + random_range(-12, 12))
//		instance_destroy()
//	}
//}

if not --spawn_timer {
	spawn_timer = 3
	repeat 1
		obj_effects.explosion(x + random_range(-12, 12), y + random_range(-12, 12))
	if not --count_to_death {
		repeat 8
			obj_effects.explosion(x + random_range(-18, 18), y + random_range(-18, 18))
		obj_effects.create_debris(x, y, choose(2, 3))
		obj_effects.explosion_big(x, y)
		instance_destroy()
	}
}


dir += rot_sp
scr_move_contact_obj(sp, move_dir, obj_block)
