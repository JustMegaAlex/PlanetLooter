
scr_debug_show_var("level", global.level)
scr_debug_show_var("ships", instance_number(obj_enemy))
scr_debug_show_var("turrets", instance_number(obj_turret))
scr_debug_show_var("graph", 
	variable_struct_names_count(global.astar_graph.graph))
var w = scr_camw(0)
var t = tips_text
if !show_tips
	t = tips_header

var xx = w - 200 + show_tips_xoffset // * show_tips
draw_text_custom(xx, 20, t, fnt_gui, -1, -1)

if TEST_PATH_FIND
	scr_debug_show_var("test time", test_time)
