
event_inherited()

if ph1_distance {
	ph1_distance -= sp
	if ph1_distance <= 0 {
		sp = weapon.ph2_sp
		image_index = weapon.ph2_img
	}
}

