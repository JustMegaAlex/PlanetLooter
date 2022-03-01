
function move_to_planet(num) {
	if not global.DEBUG
		return 0
	var planet = instance_find(obj_planet, num)
	obj_looter.x = planet.x
	obj_looter.y = planet.y
}

current_planet = 0

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

testPathFinding = {
	start: new Vec2d(0, 0),
	finish: new Vec2d(0, 0),
	graph: undefined,
	path: undefined,
	step_event: function() {
		if mouse_check_button_pressed(mb_left) {
			self.start = new Vec2d(mouse_x, mouse_y)
			self.graph.clear_all_scores()
			self.path = astar_find_path(start, finish)
		}
		if mouse_check_button_pressed(mb_right) {
			self.finish = new Vec2d(mouse_x, mouse_y)
			self.graph.clear_all_scores()
			self.path = astar_find_path(start, finish)
		}
		if keyboard_check_pressed(ord("N"))
			graph.DebugDrawer.switch_iteration(1)
		if keyboard_check_pressed(ord("B"))
			graph.DebugDrawer.switch_iteration(-1)
	},
	draw_event: function() {
		if is_array(self.path) {
			for (var i = 0; i < array_length(self.path) - 1; ++i) {
			    var p = self.path[i]
				var pp = self.path[i + 1]
				if point_in_camera(p.X, p.Y, 0) or point_in_camera(pp.X, pp.Y, 0)
					draw_line_color(p.X, p.Y, pp.X, pp.Y, c_yellow, c_yellow)
			}
		}
		self.graph.DebugDrawer.draw()
	}
}

make_late_init()
