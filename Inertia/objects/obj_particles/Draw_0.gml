
for (var i = 0; i < ds_list_size(particles); i++) {
	var p = particles[| i]
	p.update_pos()
    draw_point(p.getx(), p.gety())
}
