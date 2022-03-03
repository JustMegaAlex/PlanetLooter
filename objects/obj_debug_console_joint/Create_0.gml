
name = "default_joint"
action_function  = undefined
xcenter = x + sprite_width * 0.5
ycenter = y + sprite_height * 0.5
width = sprite_width

function setup() {
    width = obj_debug_console.joint_width
	x = window_get_width() - width
	xcenter = x + width * 0.5
	image_xscale = width / sprite_width
}
