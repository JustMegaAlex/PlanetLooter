
event_inherited()

function set_resource_data(rdata) {
	resource_data = rdata
	resource_start_ammount = rdata.ammount
	resource_fract_ammount = rdata.ammount
}


function set_hit(weapon) {
	hp -= weapon.mining
	if resource_data.ammount {
		resource_fract_ammount = resource_start_ammount * hp / hp_start
		var _ammount = ceil(resource_fract_ammount)
		if _ammount < resource_data.ammount {
			var spawn_ammount = resource_data.ammount - _ammount
			repeat spawn_ammount
				spawn_resource_item(resource_data.type, x, y, 1, random(360))
			resource_data.ammount = _ammount
			if !resource_data.ammount {
				resource_data.type = Resource.empty
				resource_data.tile_index = 0
			}
			planet_inst.tiles_redraw_resource_tile(i, j)
		}
	}
	if hp <= 0 {
		instance_destroy()
	}
}

hsp = 0
vsp = 0
hp_start = 8
hp = hp_start
image_speed = 0
resource_data = noone
resource_start_ammount = 0
resource_fract_ammount = 0
i = -1
j = -1
planet_inst = noone
is_moving_object = false
