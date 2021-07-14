
enum Resource {
	empty,
	ore,
	organic,
	metall,
	fuel,
	part,
	types_number
}

function ResourceData(type, ammount, tile_index) constructor {
	self.type = type
	self.ammount = ammount
	self.tile_index = tile_index
}

function generate_terrain(tmesh) {
	var size = array_length(tmesh)
	var gradsize = perlin_grads_cell_size
	var pmesh = perlin_mesh(size, size, gradsize, gradsize)
	temp_mesh = pmesh
	var resources = perlin_mesh(size, size, gradsize, gradsize)
	for (var i = 1; i < size - 1; ++i) {
	    for (var j = 1; j < size - 1; ++j) {
			var modified_val = modify_cell_value(pmesh[i][j], i, j)
			var terrain_type = get_cell_type(modified_val)
			if terrain_type == noone
				continue
			var rdata = get_resource_data_by_mesh(resources[i][j])
			tmesh[@ i][@ j] = terrain_add(i, j, terrain_type, rdata)
		}
	}
	return tmesh
}

function modify_cell_value(val, i, j) {
	var rad = size / 2
	var ri = abs(rad - i)
	var rj = abs(rad - j)
	var r = max(ri, rj)
	if r > core_size
		return val
	if r == 0
		return 1
	var add = power(1/r, 2)
	return val + add
}

function get_cell_type(val) {
	if val >= fill_factor
		return obj_block
	return noone
}

_resource_data = [
	[0.4, Resource.empty, 0, 0],
	[0.6, Resource.ore, 2, 1],
	[0.8, Resource.ore, 6, 2],
	[1, Resource.ore, 15, 3],
]

function get_resource_data_by_mesh(val) {
	for (var i = 0; i < array_length(_resource_data); ++i) {
		var data = _resource_data[i]
		var min_mesh_val = data[0]
		var type = data[1]
		var max_ammount = data[2]
		var tile_index = data[3]
	    if val <= min_mesh_val {
			var ammount = round(val/min_mesh_val * max_ammount)
			return new ResourceData(type, ammount, tile_index)
		}
	}
	throw " :get_resource_data_by_mesh: input error val = " + string(val)

}

function get_resource_tile_index_by_ammount(ammount) {
	for (var i = 0; i < array_length(_resource_data); ++i) {
		var data = _resource_data[i]
		var max_ammount = data[2]
	    if ammount <= max_ammount {
			var tile_index = data[3]
			return tile_index
		}
	}
}

function terrain_add(i, j, terrain_type, resdata) {
	var inst = instance_create_layer(0, 0, layer, terrain_type)
	inst.x = gridx(i-1) + x0
	inst.y = gridy(j-1) + y0
	inst.i = i
	inst.j = j
	inst.planet_inst = id
	inst.resource_data = resdata
	return inst
}

function terrain_remove(i, j) {
	terrain_mesh[i][j] = noone
	tilemap_set(tile_map_resources_id, 0, i, j)
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

function tiles_redraw_resource_tile(i, j) {
	var ammount = terrain_mesh[i][j].resource_data.ammount
	var rdata = get_resource_tile_index_by_ammount(ammount)
	tilemap_set(tile_map_resources_id, rdata, i, j)
}

function _draw_tile(i, j, burned) {
	// terrain
	var tile_index = self.compute_tile_index(i, j) + burned * 16
	var tdata = tile_index | 0 | 0
	tilemap_set(tile_map_id, tdata, i, j)
	// resources
	if terrain_mesh[i][j] {
		var r_tile_index = terrain_mesh[i][j].resource_data.tile_index
		var r_tdata = r_tile_index | 0 | 0
		tilemap_set(tile_map_resources_id, r_tdata, i, j)
	}
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


visible = true
size = 20
radius = global.grid_size * size * 0.5
x0 = x - radius
y0 = y - radius

// gen terrain
fill_factor = 0.45
core_size = 4
perlin_grads_cell_size = 4
terrain_mesh = array2d(size+2, size+2, noone)
resource_mesh = array2d(size+2, size+2, noone)
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
tile_map_resources_id = layer_tilemap_create("tiles_resources",
											left_coord() - global.grid_size,
											top_coord() - global.grid_size,
											ts_planet_resources,
											tm_size,
											tm_size)
// bgr tiles
var bgr_tile_size = 16
var bgr_size = global.grid_size / bgr_tile_size * tm_size
bgr_size = floor(bgr_size)
var bgr_mesh = perlin_mesh(bgr_size, bgr_size, perlin_grads_cell_size, perlin_grads_cell_size)
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
