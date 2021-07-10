
function set_hit() {
	hp -= obj_looter.damage
	if hp <=0 {
		instance_destroy()
	}
}

function set_resource_type(type) {
	resource_type = type
	image_index = type
}

hsp = 0
vsp = 0
hp = 4
image_speed = 0
resource_type = Resource.empty
