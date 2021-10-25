
scr_debug_show_var("level", global.level)
scr_debug_show_var("ships", instance_number(obj_enemy))
scr_debug_show_var("turrets", instance_number(obj_turret))
var w = scr_camw(0)
var t = tips_text
if !show_tips
	t = tips_header

var xx = w - 200 + show_tips * show_tips_xoffset
draw_text_custom(xx, 20, t, fnt_gui, -1, -1)

if TEST_PATH_FIND
	scr_debug_show_var("test time", test_time)
