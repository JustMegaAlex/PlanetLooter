
function move_to_planet(num) {
	if not global.DEBUG
		return 0
	var planet = instance_find(obj_planet, num)
	obj_looter.x = planet.x
	obj_looter.y = planet.y
}

current_planet = 0
show_planets_data = false
enable_instant_planet_move = false

state = "none"
editor_objects_list = [obj_enemy, obj_dummy, obj_planet]
editor_objects_list = []
editor_buttons_delta_y = 32
editor_current_object = noone
editor_x = 10
editor_y = 50
mouse_over = noone
for (var i = 0; i < array_length(editor_objects_list); ++i) {
	var xx = editor_x
	var yy = editor_y + i * editor_buttons_delta_y
    var btn = instance_create_layer(xx, yy, layer, obj_gui_toggle_button)
	var obj = editor_objects_list[i]
	btn.ui_parent = id
	btn.ui_sprite = object_get_sprite(obj)
	btn.sprite_index = spr_toggle_button
	btn.action_struct = {
		object: obj,
		action: function() {
			obj_debug.editor_current_object = self.object	
		}
	}
}