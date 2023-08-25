
if instance_exists(obj_looter) and !global.ai_attack_off {
	var dist = inst_dist(obj_looter)
	if dist < vision_range {
		if !collision_line(x, y, obj_looter.x, obj_looter.y, obj_block, false, false) {
			angle_to = inst_dir(obj_looter)
			if !--reloading {
				weapon.shoot(angle, id)
				reloading = reload_time
			}
		}
	}
}

var _diff = angle_difference(angle, angle_to)
angle = approach(angle, angle - _diff, rotary_sp)
