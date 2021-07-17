
ui_object = obj_shipyard_ui

function interface() {
	if ui_object != noone {
		var ui = instance_create_layer(x, y - 50, "ui", ui_object)
		ui.parent = id
		global.ui_interface_on = true
	}
}

size = sprite_get_height(sprite_index) / global.grid_size
