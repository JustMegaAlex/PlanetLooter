
function free(_x, _y) {
	return not place_meeting(_x, _y, obj_inner_area)	
}

function bound(x, y, rot, reverse) {
	var bnd = instance_create_layer(x, y, layer, obj_bound)
	bnd.image_angle = rot * (-90)
	if reverse
		bnd.image_yscale = -1
}

alarm[0] = 1
alarm[1] = 2
