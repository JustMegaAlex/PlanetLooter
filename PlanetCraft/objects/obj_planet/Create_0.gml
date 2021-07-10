
function generate_terrain() {
	var mesh = perlin_mesh(size)
	for (var i = 0; i < size; ++i) {
	    for (var j = 0; j < size; ++j) {
			var terrain_cell_type = get_cell_type(mesh[i][j])
			var cell = instance_create_layer(0, 0, layer, terrain_cell_type)
			terrain_add(i, j, cell)
		}
	}
}

function terrain_add(i, j, inst) {
	
}

terrain_mesh = []
size = 10

terrain_mesh = generate_terrain()
