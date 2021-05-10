
x = carrier.x
y = carrier.y

scale += growsp

image_xscale = scale
image_yscale = scale

if scale >= 1 {
	if instance_exists(obj_man)
		with instance_create_layer(x, y, layer, obj_blob) {
			image_angle = point_direction(x, y, obj_man.x, obj_man.y)
			side = other.side
		}
	carrier.projectile = noone
	instance_destroy()
}
