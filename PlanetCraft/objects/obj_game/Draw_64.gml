
scr_debug_show_var("planets", instance_number(obj_planet))
scr_debug_show_var("enemies", instance_number(obj_enemy))
scr_debug_show_var("level", global.level)
var w = scr_camw(0)
var t = tips_text
if !show_tips
	t = tips_header

draw_text_custom(w - 200, 20, t, fnt_gui, -1, -1)
