
function shoot(shoot_dir) {
	reloading = reload_time
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
	}
}

function add_resource(type, ammount) {
	if (resources[type] + ammount) > resource_max_ammount
		show_error(" :add_resource: resource type ammount > max ammount", false)
	resources[type] += ammount
}

function check_resource_full(type) {
	return resources[type] >= resource_max_ammount
}

sp = 5
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.5
decel = 0.2
hacc = 0
vacc = 0
input_h = 0
input_v = 0
move_h = 0
move_v = 0
input_dir = 0

shoot_h = 0
shoot_v = 0
shoot_dir = 0
reload_time = 5
reloading = 0

grav = 0.05
gravx = 0
gravy = 0
gravity_dist = 300
gravity_min_dist = 8

resources = array_create(Resource.types_number, 0)
resource_max_ammount = 10

current_planet = noone
