
event_inherited()

enum Building {
	hostile,
	friendly,
	unhappy, // slave state
}

function add_defender(inst) {
	array_push(defenders, inst)
}

function pop_defender(inst) {
	array_remove(defenders, inst)
	if not array_length(defenders)
		state = Building.unhappy
}

function place_on_planet() {
	var side = irandom(4)
	var r = planet.radius
	var ps = planet.size
	while true {
		var side_pos = gridx(irandom(ps - size))
		image_angle = side * 90
		var x_factor = lengthdir_x(1, image_angle)
		var y_factor = lengthdir_y(1, image_angle)
		// angle = 0 --> x = r
		// angle = 90 --> x = side_pos - r
		x = planet.x + r * x_factor + (side_pos - r) * y_factor
		y = planet.y + r * y_factor + (side_pos - r) * x_factor
		if not place_meeting(x, y, obj_building)
			break
		// create foundation blocks
		// ToDo
	}
}

visible = false
alarm[0] = 1

size = sprite_get_height(sprite_index) / global.grid_size

ui_object = noone

hp = 20
side = Sides.neutral
state = Building.friendly
defenders = []

// creation arguments
planet = noone
assign_creation_arguments()
