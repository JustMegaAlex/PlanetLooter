
event_inherited()

function set_resource_data(rdata) {
	resource_data = rdata
	resource_start_amount = rdata.amount
	resource_fract_amount = rdata.amount
}


function set_hit(attacker, weapon) {
	hp -= weapon.mining
	if resource_data.amount {
		resource_fract_amount = resource_start_amount * hp / hp_start
		var _amount = ceil(resource_fract_amount)
		if _amount < resource_data.amount {
			var spawn_amount = resource_data.amount - _amount
			repeat spawn_amount
			var _dir = instance_exists(attacker) ? inst_dir(attacker) + random_range(-45, 45) : random(360)
			spawn_resource_item(resource_data.type, x, y, 0.5, _dir)
			resource_data.amount = _amount
			if !resource_data.amount {
				resource_data.type = "empty"
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
resource_start_amount = 0
resource_fract_amount = 0
i = -1
j = -1
planet_inst = noone
is_moving_object = false
