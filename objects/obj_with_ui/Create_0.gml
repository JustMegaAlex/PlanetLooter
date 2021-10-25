
event_inherited()

function interface() {
	if ui_object != noone {
		ui_inst = instance_create_layer(x, y - 50, "ui", ui_object)
		ui_inst.parent = id
		global.ui_interface_on = true
	}
}

ui_inst = noone
ui_object = noone
