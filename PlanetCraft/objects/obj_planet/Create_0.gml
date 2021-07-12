
enum Resource {
	empty,
	ore,
	organic,
	metall,
	fuel,
	part,
	types_number
}

function generate_terrain(tmesh) {
	var size = array_length(tmesh)
	var pmesh = perlin_mesh(size, size)
	var resources = perlin_mesh(size, size)
	for (var i = 1; i < size - 1; ++i) {
	    for (var j = 1; j < size - 1; ++j) {
			var terrain_type = get_cell_type(pmesh[i][j])
			if terrain_type == noone
				continue
			var resource_type = get_resource_type(resources[i][j])
			tmesh[@ i][@ j] = terrain_add(i, j, terrain_type, resource_type)
		}
	}
	return tmesh
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

function terrain_add(i, j, terrain_type, resource_type) {
	var inst = instance_create_layer(0, 0, layer, terrain_type)
	inst.x = gridx(i-1) + x0
	inst.y = gridy(j-1) + y0
	inst.i = i
	inst.j = j
	inst.planet_inst = id
	inst.set_resource_type(resource_type)
	return inst
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
	for (var i = 0; i < tm_size; ++i) {
	    for (var j = 0; j < tm_size; ++j) {
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

function collapse_mesh_cells(mesh, bound_value) {
	var size = array_length(mesh)
	for (var i = 1; i < size; ++i) {
	    for (var j = 1; j < size; ++j) {
			mesh[@i][@j] = (mesh[i][j] > bound_value) ? 1 : 0
		}
	}
	return mesh
}


visible = false
size = 20
radius = global.grid_size * size * 0.5
x0 = x - radius
y0 = y - radius
terrain_mesh = array2d(size+2, size+2, noone)
fill_factor = 0.5
terrain_mesh = generate_terrain(terrain_mesh)

//terrain_mesh = [
//	[0, 0, 0, 0, 0],
//	[0, 0, 1, 0, 0],
//	[0, 0, 1, 1, 0],
//	[0, 0, 1, 0, 0],
//	[0, 0, 0, 0, 0],
//]

//// tiles
tm_size = size + 1
tile_map_id = layer_tilemap_create("tiles",
								left_coord() - global.grid_size * 0.5,
								top_coord() - global.grid_size * 0.5,
								ts_planet_ground,
								tm_size,
								tm_size)
// bgr tiles
var bgr_tile_size = 16
var bgr_size = global.grid_size / bgr_tile_size * tm_size
bgr_size = floor(bgr_size)
var bgr_mesh = perlin_mesh(bgr_size, bgr_size)
var farbgr_size = bgr_size - 1
var farbgr_mesh = array2d(farbgr_size, farbgr_size, 1)
// zero edges
for (var i = 0; i < bgr_size; ++i) {
    bgr_mesh[i][bgr_size-1] = 0
	bgr_mesh[bgr_size-1][i] = 0
	bgr_mesh[i][0] = 0
	bgr_mesh[0][i] = 0
	farbgr_mesh[i][farbgr_size-1] = 0
	farbgr_mesh[farbgr_size-1][i] = 0
	farbgr_mesh[i][0] = 0
	farbgr_mesh[0][i] = 0
}
bgr_mesh = collapse_mesh_cells(bgr_mesh, 0.35)
autotiler_bgr = new Autotiling("tiles_bgr",
								left_coord(),
								top_coord(),
								ts_planet_ground_bgr,
								bgr_size-1,
								bgr_size-1,
								bgr_mesh,
								0)
autotiler_farbgr = new Autotiling("tiles_farbgr",
								left_coord() + bgr_tile_size * 0.5,
								top_coord() + bgr_tile_size * 0.5,
								ts_planet_ground_farbgr,
								farbgr_size-1,
								farbgr_size-1,
								farbgr_mesh,
								0)
draw_tiles()
autotiler_bgr.draw_region(0, 0, bgr_size - 1, bgr_size - 1)
autotiler_farbgr.draw_region(0, 0, farbgr_size - 1, farbgr_size - 1)
