

function ResourceData(type, ammount, tile_index) constructor {
	self.type = type
	self.ammount = ammount
	self.tile_index = tile_index
}

function generate_terrain(tmesh) {
	var size = array_length(tmesh)
	var gradsize = perlin_grads_cell_size
	var pmesh = perlin_mesh(size, size, gradsize, gradsize)
	var resources = perlin_mesh(size, size, gradsize, gradsize)
	for (var i = 1; i < size - 1; ++i) {
	    for (var j = 1; j < size - 1; ++j) {
			var modified_val = modify_cell_value(pmesh[i][j], i, j)
			var terrain_type = get_cell_type(modified_val)
			if terrain_type == noone
				continue
			
			var rdata = get_resource_data_by_mesh(resources[i][j])
			// make more organic on planet surface
			if rdata.type != "empty" {
				var modified_val_r = modify_resource_value(resources[i][j], i, j, rdata.type)
				rdata = get_resource_data_by_mesh(modified_val_r)
			}
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

function modify_resource_value(val, i, j, type) {
	// shifts resource mesh val
	// so on planet surface there will be more organic
	// -0.3, -0.25, 0.2, 0.2, 0.25, 0.3
	var add = 0
	var d = depth_at(i, j)
	if (d < organic_layer_depth) and (type == "ore")
		var add = -0.3 + d * (0.05)
	else if (d >= organic_layer_depth) and (type == "organic")
		var add = 0.2 + d * (0.05)
	add = clamp(add, -0.3, 0.3)
	if (val + add) > 1
		test = true
	return val + add
}

function depth_at(i, j) {
	// r = 10
	//( 3, 16) -> 3
	//( 3, 18) -> 2
	var rad = size / 2
	var idepth = (i < rad) ? i : (rad - (i mod rad)) // 3
	var jdepth = (j < rad) ? j : (rad - (j mod rad)) // 4
	var d = min(idepth, jdepth)
	return d
}

function get_cell_type(val) {
	if val >= fill_factor
		return obj_block
	return noone
}

_resource_data = [
	// [_min_mesh_val, type, max_ammount, tile_index]
	[0.8, "empty", 0.01, 0],
	[0.85, "organic", 2, 4],
	[0.88, "organic", 4, 5],
	[0.9, "organic", 8, 6],
	[0.95, "ore", 2, 1],
	[0.99, "ore", 6, 2],
	[1, "ore", 15, 3],
	//[0.3, "empty, 0.01, 0],
	//[0.43, "organic, 2, 4],
	//[0.47, "organic, 4, 5],
	//[0.50, "organic, 8, 6],
	//[0.7, "ore, 2, 1],
	//[0.8, "ore, 6, 2],
	//[1, "ore, 15, 3],
]

function reset_resource_data(gain) {
	var total_delta = _resource_data[0][0] * gain
	var delta_per_resource = total_delta / (array_length(_resource_data) - 1)
	_resource_data[0][0] -= total_delta
	for (var i = 1; i < array_length(_resource_data) - 1; ++i) {
		_resource_data[i][0] -= delta_per_resource
	}
}

function get_resource_data_by_mesh(val) {
	if val > 1
		test = true
	var type, ammount, tile_index, max_ammount
	for (var i = 0; i < array_length(_resource_data); ++i) {
		var data = _resource_data[i]
		var min_mesh_val = data[0]
		type = data[1]
		max_ammount = data[2]
		tile_index = data[3]
	    if val <= min_mesh_val {
			ammount = round(val/min_mesh_val * max_ammount)
			return new ResourceData(type, ammount, tile_index)
		}
	}
	return new ResourceData(type, max_ammount, tile_index)
	//throw " :get_resource_data_by_mesh: input error val = " + string(val)

}

function get_resource_tile_index_by_ammount(ammount, type) {
	for (var i = 0; i < array_length(_resource_data); ++i) {
		var data = _resource_data[i]
		var _type = data[1]
		if type != _type
			continue
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
	inst.set_resource_data(resdata)
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
	var type = terrain_mesh[i][j].resource_data.type
	var rdata = get_resource_tile_index_by_ammount(ammount, type)
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
size = global._level_gen_planet_size
background_is_drawn = global._level_gen_planet_background


radius = global.grid_size * size * 0.5
x0 = x - radius
y0 = y - radius

// gen terrain
fill_factor = 0.45
core_size = 4
organic_layer_depth = 3
perlin_grads_cell_size = 4


radius = global.grid_size * size * 0.5
x0 = x - radius
y0 = y - radius

// gen terrain
fill_factor = 0.45
resource_ammount_gain = random(0.25)
reset_resource_data(resource_ammount_gain)

core_size = 4
organic_layer_depth = 3
perlin_grads_cell_size = 4
terrain_mesh = array2d(size+2, size+2, noone)
resource_mesh = array2d(size+2, size+2, noone)
terrain_mesh = generate_terrain(terrain_mesh)

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
draw_tiles()

if background_is_drawn {
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
	autotiler_bgr.draw_region(0, 0, bgr_size - 1, bgr_size - 1)
	autotiler_farbgr.draw_region(0, 0, farbgr_size - 1, farbgr_size - 1)

	//terrain_mesh = [
	//	[0, 0, 0, 0, 0],
	//	[0, 0, 1, 0, 0],
	//	[0, 0, 1, 1, 0],
	//	[0, 0, 1, 0, 0],
	//	[0, 0, 0, 0, 0],
	//]
}

/// debug
patrol_points = planet_get_route_points(id)

collider_obj = instance_create_args(x, y, layer,
									obj_planet_mask,
									{size: size, planet_inst: id})
