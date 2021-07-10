
enum Resource {
	empty,
	ore,
	types_number
}

function generate_terrain() {
	var mesh = perlin_mesh(size, size)
	var resources = perlin_mesh(size, size)
	for (var i = 0; i < size; ++i) {
	    for (var j = 0; j < size; ++j) {
			var terrain_cell_type = get_cell_type(mesh[i][j])
			if terrain_cell_type == noone
				continue
			var cell = instance_create_layer(0, 0, layer, terrain_cell_type)
			var resource_type = get_resource_type(resources[i][j])
			terrain_add(i, j, cell, resource_type)
		}
	}
}

function get_cell_type(val) {
	if val >= fill_factor
		return obj_block
	return noone
}

function get_resource_type(val) {
	if val >= 0.5
		return Resource.ore
	return Resource.empty
}

function terrain_add(i, j, inst, rs_type) {
	terrain_mesh[i][j] = inst
	inst.x = gridx(i) + x0
	inst.y = gridy(j) + y0
	inst.set_resource_type(rs_type)
}

size = 20
var radius = global.grid_size * size * 0.5
x0 = x - radius
y0 = y - radius
terrain_mesh = array2d(size, size, noone)
fill_factor = 0.5
generate_terrain()
