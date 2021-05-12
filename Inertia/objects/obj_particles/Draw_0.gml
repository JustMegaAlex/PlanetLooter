
if instance_exists(obj_man) {
	for (var i = 0; i < ds_list_size(particles); i++) {
		var p = particles[| i]
		p.update_pos()
	    draw_sprite(spr_photonie, 0, p.getx(), p.gety())
	}
}
