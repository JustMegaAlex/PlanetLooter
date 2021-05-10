
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
}

hsp = lengthdir_x(sp, dir)
vsp = lengthdir_y(sp, dir)
if scr_move_contact(hsp, vsp)
	state = States.stop
