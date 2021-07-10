
generate_star_system()
global.game_over = false
instance_create_layer(0, 0, "stars", obj_stars)
instance_create_layer(0, 0, "Instances", obj_effects)
if not instance_exists(obj_looter)
	instance_create_layer(0, 0, "Instances", obj_looter)
object_set_persistent(obj_looter, false)
