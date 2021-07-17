
function add_item(spr, text, action_struct) {
	var item = instance_create_layer(x, y, layer, obj_ui_item)
	item.ui_sprite = spr
	item.text = text
	item.action_struct = action_struct
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
		it.ui_parent = id
	}
}

function ui_message(text, warning) {
	override_displaying = override_displaying_time
	display_text = text
	if warning
		image_index = 1
}

function Productor(resource, ui_parent) constructor {
	self.type = resource
	self.type_name = global.resource_names[resource]
	self.ui_parent = ui_parent
	action = function() {
		var cost = variable_struct_get(global.ResourceCost, self.type_name)
		var msg = obj_looter.exchange_resources(self.type, 1, cost.type, cost.ammount)
		if msg != "ok"
			self.ui_parent.ui_message(msg, true)
	}
}

items = []
items_number = 0
ui_radius = 128
ui_angle_step = 60
sprite_index = spr_building_ui
image_speed = 0
display_text = ""
mouse_over = noone
mouse_pressed = false
override_displaying_time = 60
override_displaying = 0
parent = noone

disconnect_dist = 200

// late init: setup ui
alarm[0] = 1
