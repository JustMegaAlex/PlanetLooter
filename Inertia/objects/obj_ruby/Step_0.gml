
event_inherited()
if instance_exists(obj_man)
	if projectile == noone and point_distance(x, y, obj_man.x, obj_man.y) < shootdist {
		projectile = instance_create_layer(x, y, layer, obj_blob_creation)
		projectile.carrier = self
		projectile.side = side
	}

switch state {
	case States.stop: {
		sp = scr_approach(sp, 0, acc)
		update_segments()
		if sp == 0 {
			state = States.scan
		}
		break
	}
	case States.scan: {
		var dirs_dist, dist, dirs
		if scr_chance(0.25) {
			while dir == image_angle
				dir = choose(0, 90, 180, 270)
			dist = scandist*0.15
		} else {
			if scr_chance(0.5)
				dirs_dist = scan_dirs(scandist*0.5)
			else
				dirs_dist = scan_dirs(scandist)
			dirs = dirs_dist[0]
			dist = dirs_dist[1] - wanderdist_delta
			dist = max(0, dist)
			dir = dirs[irandom(array_length(dirs)-1)]
		}		
		xto = x + lengthdir_x(dist, dir)
		yto = y + lengthdir_y(dist, dir)
		state = States.wander
		image_angle = dir
		update_segments()
		break
	}

	case States.wander: {
		sp = scr_approach(sp, spmax, acc)
		update_segments()
		if point_distance(x, y, xto, yto) < sp
			state = States.stop
	}
}

hsp = lengthdir_x(sp, dir)
vsp = lengthdir_y(sp, dir)
if scr_move_contact(hsp, vsp)
	state = States.stop
