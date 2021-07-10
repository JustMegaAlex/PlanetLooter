
function shoot(shoot_dir) {
	reloading = reload_time
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
	}
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
acc_dir = 0

shoot_h = 0
shoot_v = 0
shoot_dir = 0
reload_time = 5
reloading = 0
