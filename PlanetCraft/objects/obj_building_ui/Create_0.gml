
function add_item(spr, text, action_method) {
	var item = instance_create_layer(x, y, layer, obj_ui_item)
	item.ui_sprite = spr
	item.text = text
	item.action_method = action_method
	array_push(items, item)
	items_number++
}

function setup_ui() {
	var start_angle = 90 + (items_number - 1) * ui_angle_step * 0.5
	for (var i = 0; i < items_number; ++i) {
	    var it = items[i]
		var cur_angle = start_angle - i * ui_angle_step
		it.x = x + lengthdir_x(ui_radius, cur_angle)
		it.y = y + lengthdir_y(ui_radius, cur_angle)
	}
}

items = []
items_number = 0
ui_radius = 64
ui_angle_step = 30
sprite_index = spr_building_ui

// late init: setup ui
alarm[0] = 1
