
event_inherited()

function set_resource_type(type) {
	resource_type = type
	image_index = type
}


function set_hit(dmg) {
	if resource_data.ammount {
		var collectable = instance_create_layer(x, y, layer, obj_collectable)
		collectable.set_resource_type(resource_data.type)
		resource_data.ammount--
		planet_inst.tiles_redraw_resource_tile(i, j)
	}
	hp -= dmg
	if hp <= 0 {
		instance_destroy()
	}
}

hsp = 0
vsp = 0
hp = 8
image_speed = 0
resource_data = noone
i = -1
j = -1
planet_inst = noone
is_moving_object = false
