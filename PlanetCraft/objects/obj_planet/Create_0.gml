
function generate_terrain() {
	var mesh = perlin_mesh(size, size)
	for (var i = 0; i < size; ++i) {
	    for (var j = 0; j < size; ++j) {
			var terrain_cell_type = get_cell_type(mesh[i][j])
			if terrain_cell_type == noone
				continue
			var cell = instance_create_layer(0, 0, layer, terrain_cell_type)
			terrain_add(i, j, cell)
		}
	}
}

function get_cell_type(val) {
	if val >= 0.5
		return obj_block
	return noone
}

function terrain_add(i, j, inst) {
	terrain_mesh[i][j] = inst
	inst.x = gridx(i)
	inst.y = gridy(j)
}

size = 20
terrain_mesh = array2d(size, size, noone)
generate_terrain()
