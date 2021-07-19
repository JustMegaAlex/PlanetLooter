
scr_debug_ini()
global.DEBUG = true
window_set_cursor(cr_none)
cursor_sprite = spr_aim

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

show_tips = false
tips_text = "WASD to move\nMouse to shoot\nE to interact with buidlings\nR to restart\n"
tips_text += "hold F to activate cruise mode\n"
tips_text += "F11 toggle fullscreen (and make those shiny stars disappear)\n"
tips_text += "compass arrows point to planets\n"
tips_text += "When you have 10 fuel hold space to warp\n"
tips_header = "Press T to show tips"

instance_create_layer(0, 0, layer, obj_level_gen)
