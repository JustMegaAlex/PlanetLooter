
global.game_over = false
global.ui_interface_on = false
instance_create_layer(0, 0, "stars", obj_stars)
instance_create_layer(0, 0, "Instances", obj_effects)
if not instance_number(obj_looter)
	instance_create_layer(0, 0, "Instances", obj_looter)

// late init
alarm[0] = 1
