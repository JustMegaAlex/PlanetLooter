
enum Enemy {
	idle,
	wander,
	enclose,
	distantiate,
}

function shoot(shoot_dir) {
	reloading = reload_time
	with(instance_create_layer(x, y, layer, obj_bullet)) {
		self.image_angle = shoot_dir
	}
}

state = "idle"

sp = 2.5
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.25
decel = 0.2

detection_dist = 300
loose_dist = 400
close_dist = 150
target = noone

shoot_dir = 0
reload_time = 30
reloading = 0
