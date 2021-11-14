
event_inherited()

displaying_timer = 0
text_display_time = 40
text_yoffset = 40

function show_prompt() {
	is_showing_prompt = true
}

function ui_message(text) {
	displaying_timer = text_display_time
	display_text = text
}

UI_menu = {
	parent: id,
	on_press_interact: function() {
		if parent.ui_object != noone {
			parent.ui_inst =
				instance_create_layer(parent.x, parent.y - 50, "ui", parent.ui_object)
			parent.ui_inst.parent = parent
			is_showing_prompt_on = false
			is_ui_on = true
			global.ui_interface_on = true
		}
	},
	on_hold_interact: function() {},
	turn_off: function() {
		is_ui_on = false
		is_showing_prompt_on = true
		instance_destroy(parent.ui_inst)
		global.ui_interface_on = false
	},
	step_event: function() {},
	draw_event: function() {}
}

UI_button_accum = {
	parent: id,
	on_hold_on: false,
	on_hold_filled: 0,
	on_hold_fill_ratio: 0.01,
	x_offset: 30,
	y_offset: -30,
	on_press_interact: function() {},
	ui_turn_off: function() {},
	on_hold_interact: function() {
		var msg = obj_looter
				  .Resources
				  .has_enough_of_cost(global.raction_repairment.cost)
		if msg != "ok" {
			parent.ui_message(msg)
			return false
		}
		on_hold_filled = approach(on_hold_filled, 1, on_hold_fill_ratio)
		on_hold_on = true
	},
	step_event: function() {
		if !on_hold_on { on_hold_filled = 0 }
		if on_hold_filled == 1 {
			obj_looter.hp += 1
			obj_looter.Resources.exchange("empty", 1,
							global.raction_repairment.cost)
			on_hold_filled = 0
		}
		on_hold_on = false
	},
	draw_event: function() {
		var w = sprite_get_width(parent.ui_sprite) * on_hold_filled
		var h = sprite_get_height(parent.ui_sprite)
		if on_hold_filled > 0 {
			var xx = obj_looter.x + x_offset
			var yy = obj_looter.y + y_offset
			draw_sprite(parent.ui_sprite, 0, xx, yy)
			draw_sprite_part(parent.ui_sprite, 1, 0, 0, w, h, xx, yy)
		}
	}
}

UI = noone
ui_object = noone
ui_inst = noone
ui_sprite = noone
ui_on_press_interact = noone
ui_default_prompt_text = "E"
ui_prompt_text = ui_default_prompt_text
is_showing_prompt = false
is_showing_prompt_on = true

make_late_init()
