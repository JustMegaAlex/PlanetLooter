
event_inherited()

function move() {
	homing_distance -= weapon.sp	
	if homing_distance {
		obj_effects.jet(x, y)
		if not instance_exists(target) {
			if not set_target() {
				scr_move(sp, image_angle)
				return false
			}
		}
		var target_dir = inst_dir(target)
		var diff = angle_difference(target_dir, image_angle)
		if abs(diff) < rotsp
			image_angle = target_dir
		else
			image_angle += rotsp * sign(diff)
	}
	scr_move(sp, image_angle)
}

function set_target() {
	ds_list_clear(targets_list)
	collision_circle_list(x, y, homing_distance, obj_enemy, false, true, targets_list, false)
	var min_score = infinity
	var chosen = noone
	for (var i = 0; i < ds_list_size(targets_list); ++i) {
	    var inst = targets_list[| i]
		var dist = inst_dist(inst)
		var dir = inst_dir(inst)
		var delta_dir = abs(angle_difference(dir, image_angle))
		var inst_score = dist + delta_dir * 1.35
		if inst_score < min_score {
			min_score = inst_score
			chosen = inst
		}
	}
	target = chosen
	return chosen
}

visible = false
alarm[0] = 1
sp = 10
homing_distance = 400
life_distance = 1000
side = -1
spawner = noone

xprev = x
yprev = y

// homing
rotsp = 3
targets_list = ds_list_create()
target = noone
