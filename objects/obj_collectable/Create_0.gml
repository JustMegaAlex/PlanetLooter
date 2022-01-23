
function set_resource_type(type) {
	image_index = global.resource_types[$ type].img_index
	resource_type = type
}
sp_base = 3
sp_ratio = 10
sp = 0
dir = 0
decc = 0.002
pull_dist = 50
min_dist = 8
image_speed = 0
inertial_moving = true
resource_type = "empty"
collectors = ds_list_create()
