
step = sprite_get_width(spr_inner_area)

for (var i = 0; i < image_xscale; ++i) {
	var xx = x + i * step
    for (var j = 0; j < image_yscale; ++j) {
	    var yy = y + j * step
		instance_create_layer(xx, yy, layer, obj_inner_area)
	}
}

instance_destroy()
