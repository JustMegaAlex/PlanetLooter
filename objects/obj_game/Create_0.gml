
scr_debug_ini()
window_set_cursor(cr_none)
cursor_sprite = spr_aim
global.time = 0

enum Sides {
	ours,
	theirs,
	neutral,
}

global.ui_interface_on = false
global.game_over = false
global.level = 0
global._level_gen_planet_size = -1 // pass size parameter to obj_planet inst on its creation
draw_set_font(fnt)

// objects
initialize_path_finding()

show_tips = false
show_tips_xoffset = -400
tips_text = "WASD to move\nLeft mouse to shoot\nMouse wheel to switch weapons\n"
tips_text += "Right mouse to thrust\nE to interact with buidlings\nF3 to restart\n"
tips_text += "R to repair one hull point (costs 1 repair kit)\n"
tips_text += "Q to open structure-creation menu\n"
tips_text += "Hold space to warp (costs 5 fuel) \n"
tips_text += "F11 toggle fullscreen (and make those\n                          shiny stars disappear LoL)\n" 
tips_text += "Compass arrows point to planets\n"
tips_header = "Press T to show tips"

if room == rm_game
	instance_create_layer(0, 0, layer, obj_level_gen)

// degugging
if TEST_PATH_FIND {
	test_room_time_secs = 60
	test_time = test_room_time_secs
	room_speed = 600
}