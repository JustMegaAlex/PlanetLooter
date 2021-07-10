
function place_on_planet() {
	var side = irandom(4)
	var r = planet.radius
	var ps = planet.size
	var side_pos = gridx(irandom(ps - size))
	image_angle = side * 90
	var x_factor = lengthdir_x(1, image_angle)
	var y_factor = lengthdir_y(1, image_angle)
	// angle = 0 --> x = r
	// angle = 90 --> x = side_pos - r
	x = planet.x + r * x_factor + (side_pos - r) * y_factor
	y = planet.y + r * y_factor + (side_pos - r) * x_factor
	// create foundation blocks
	// ToDo
}

function interface() {
	if ui_object != noone {
		var ui = instance_create_layer(x, y - 50, "ui", ui_object)
		ui.parent = id
		global.ui_interface_on = true
	}
}

size = sprite_get_height(sprite_index) / global.grid_size
planet = choose_planet()
place_on_planet()

ui_object = noone
