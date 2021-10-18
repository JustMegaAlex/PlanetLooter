

if global.show_planets_data {
	draw_circle(x, y, radius, true)
	draw_line(left_coord(), top_coord(), right_coord(), bottom_coord())
	var i, j
	var arr = terrain_mesh
	var w = array_length(arr)
	var h = array_length(arr[0])
	var i0 = (scr_camx(0) - x0) div global.grid_size
	var j0 = (scr_camy(0) - y0) div global.grid_size
	var i1 = i0 + scr_camw(0) div global.grid_size
	var j1 = j0 + scr_camw(0) div global.grid_size
	i0 = max(0, i0)
	j0 = max(0, j0)
	i1 = min(w, i1)
	j1 = min(h, j1)
	var s
	for(i=i0;i<i1; i+=1) {
		for(j=j0; j<j1; j+=1) {
			if arr[i][j] == noone
				continue
			if !(i mod perlin_grads_cell_size) and !(j mod perlin_grads_cell_size)
				draw_circle_color(x0 + global.grid_size * (i-1),
							 y0 + global.grid_size * (j-1),
							 4, c_blue, c_blue, false)
			s = string(arr[i][j].resource_data.amount) + " " + string(arr[i][j].hp)
		    draw_text_custom(x0 + global.grid_size * (i-1),
							 y0 + global.grid_size * (j-1), s, fnt_small, -1, -1)
		}
	}
	// patrol points
	for (var i = 0; i < array_length(patrol_points); ++i) {
		var p = patrol_points[i]
	    draw_circle(p.X, p.Y, 3, false)
	}
}
