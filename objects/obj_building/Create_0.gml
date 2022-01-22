
event_inherited()

function add_defender(inst) {
	array_push(defenders, inst)
}

function pop_defender(inst) {
	array_remove(defenders, inst)
	if not array_length(defenders)
		state = Building.unhappy
}

function get_planet_placement() {
	var r = planet.radius
	var ps = planet.size
	var side = irandom(4)
	var side_pos = gridx(irandom(ps - size))
	var angle = side * 90
	var x_factor = lengthdir_x(1, angle)
	var y_factor = lengthdir_y(1, angle)
	// angle = 0 --> x = r
	// angle = 90 --> x = side_pos - r
	xx = planet.x + r * x_factor + (side_pos - r) * y_factor
	yy = planet.y + r * y_factor + (side_pos - r) * x_factor
	// adjust placement according to image offset
	xx += x_factor * sprite_xoffset
	yy += y_factor * sprite_xoffset
	return {X: xx, Y: yy, angle: angle}
}

function place_on_planet() {
	var plc
	repeat 1000 {
		plc = get_planet_placement()
		if not place_meeting(plc.X, plc.Y, obj_building)
			break
	}
	x = plc.X
	y = plc.Y
	image_angle = plc.angle
}

function place_on_planet_close_to(close_to) {
	var plc, chosen_plc
	var dist = infinity
	repeat 20 {
		repeat 1000 {
			plc = get_planet_placement()
			if not place_meeting(plc.X, plc.Y, obj_building)
				break
		}
		var _dist = point_distance(plc.X, plc.Y, close_to.X, close_to.Y)
		if _dist < dist {
			dist = _dist
			chosen_plc = plc
		}
	}
	x = chosen_plc.X
	y = chosen_plc.Y
	image_angle = chosen_plc.angle
}

visible = false
alarm[0] = 1

size = sprite_get_height(sprite_index) / global.grid_size

hp = 20
side = Sides.neutral

// creation arguments
planet = noone
place_close_to_point = noone
assign_creation_arguments()
