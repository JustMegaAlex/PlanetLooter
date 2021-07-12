
enum Resource {
	empty,
	ore,
	organic,
	metall,
	fuel,
	part,
	types_number
}

function generate_terrain() {
	var mesh = perlin_mesh(size, size)
	var resources = perlin_mesh(size, size)
	for (var i = 1; i < size; ++i) {
	    for (var j = 1; j < size; ++j) {
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
	if val >= 0.75
		return Resource.organic
	if val >= 0.5
		return Resource.ore
	return Resource.empty
}

function terrain_add(i, j, inst, rs_type) {
	terrain_mesh[i][j] = inst
	inst.x = gridx(i) + x0
	inst.y = gridy(j) + y0
	inst.i = i
	inst.j = j
	inst.planet_inst = id
	inst.set_resource_type(rs_type)
}

function terrain_remove(i, j) {
	terrain_mesh[i][j] = noone
	self.tiles_redraw_region(i - 1, j - 1, 2, 2)
}

function bottom_coord() {
	return y + radius
}

function top_coord() {
	return y - radius
}

function left_coord() {
	return x - radius
}

function right_coord() {
	return x + radius
}

function draw_tiles() {
	for (var i = 0; i < size; ++i) {
	    for (var j = 0; j < size; ++j) {
			self._draw_tile(i, j, false)
		}
	}
}

function tiles_redraw_region(i, j, ni, nj) {
	for (var ii = i; ii< i + ni; ++ii) {
	    for (var jj = j; jj < j + nj; ++jj) {
			self._draw_tile(ii, jj, true)
		}
	}
}

function _draw_tile(i, j, burned) {
	var tile_index = self.compute_tile_index(i, j) + burned * 16
	var tdata = tile_index | 0 | 0
	tilemap_set(tile_map_id, tdata, i, j)
}

function compute_tile_index(i, j) {
	return (mesh_tile_value(i, j)
			+ 2 * mesh_tile_value(i+1, j)
			+ 4 * mesh_tile_value(i, j+1)
			+ 8 * mesh_tile_value(i+1, j+1))
}

function mesh_tile_value(i, j) {
	return terrain_mesh[i][j] != noone
}


visible = false
size = 20
mesh_size = size + 2
radius = global.grid_size * size * 0.5
x0 = x - radius
y0 = y - radius
terrain_mesh = array2d(mesh_size, mesh_size, noone)
fill_factor = 0.5
generate_terrain()

//terrain_mesh = [
//	[0, 0, 0, 0, 0],
//	[0, 0, 1, 0, 0],
//	[0, 0, 1, 1, 0],
//	[0, 0, 1, 0, 0],
//	[0, 0, 0, 0, 0],
//]

//// tiles
//var layer_id = layer_get_id()
var tm_size = size
tile_map_id = layer_tilemap_create("tiles",
								left_coord() + global.grid_size * 0.5,
								top_coord() + global.grid_size * 0.5,
								ts_planet_ground,
								tm_size,
								tm_size)
draw_tiles()
