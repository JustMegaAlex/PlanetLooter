
var gui_mouse_x = window_mouse_get_x()
var gui_mouse_y = window_mouse_get_y()
image_index = 0

if collision_point(gui_mouse_x, gui_mouse_y, id, false, false) {
	image_index = 1
	if mouse_check_button_pressed(mb_left)
		action_function()
}

//draw_sprite_stretched(sprite_index, image_index, x, y, width , sprite_height)
draw_self()
draw_text_custom(xcenter, ycenter, name, fnt_gui, fa_center, fa_middle)

scr_debug_show_var("mx", mouse_x)
scr_debug_show_var("my", mouse_y)
scr_debug_show_var("mguix", gui_mouse_x)
scr_debug_show_var("mguiy", gui_mouse_y)
