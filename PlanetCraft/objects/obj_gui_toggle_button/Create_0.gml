
function toggle() {
	toggled_on = !toggled_on
	image_index = 2
	action_struct.action()
}

ui_sprite = noone
ui_parent = noone
image_speed = 0
action_struct = noone
toggled_on = false
