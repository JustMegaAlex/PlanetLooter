

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
	[0.3, "empty", 0.01, 0],
	[0.43, "organic", 2, 4],
	[0.47, "organic", 4, 5],
	[0.50, "organic", 8, 6],
	[0.7, "ore", 2, 1],
	[0.8, "ore", 6, 2],
	[1, "ore", 15, 3],
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

function terrain_add(i, j, inst, resdata) {
	terrain_mesh[i][j] = inst
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
	for (var i = 0; i < tm_w; ++i) {
	    for (var j = 0; j < tm_h; ++j) {
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
	var w = array_length(mesh)
	var h = array_length(mesh[0])
	for (var i = 1; i < w; ++i) {
	    for (var j = 1; j < h; ++j) {
			mesh[@i][@j] = (mesh[i][j] > bound_value) ? 1 : 0
		}
	}
	return mesh
}

function init_terrain() {
	for (var i = 0; i < ds_list_size(blocks); ++i) {
	    var inst = blocks[| i]
		x0 = min(inst.x, x0)
		y0 = min(inst.y, y0)
		xmax = max(inst.x, xmax)
		ymax = max(inst.y, ymax)
	}
	width = (xmax - x0) div global.grid_size
	height = (ymax - y0) div global.grid_size
	var w = width + 3
	var h = height + 3
	terrain_mesh = array2d(w, h, noone)
	resource_mesh = perlin_mesh(w, h, 3, 3)

	for (var i = 0; i < ds_list_size(blocks); ++i) {
	    var inst = blocks[| i]
		var ii = (inst.x - x0) div global.grid_size + 1
		var jj = (inst.y - y0) div global.grid_size + 1
		var rdata = get_resource_data_by_mesh(resource_mesh[ii][jj])
		terrain_add(ii, jj, inst, rdata)
	}
}


visible = true

// gen terrain
organic_layer_depth = 3
perlin_grads_cell_size = 3
resource_mesh = []
terrain_mesh = []
width = -1
height = -1
radius = -1
grav = 0
x0 = x
y0 = y
xmax = x
ymax = y
blocks = ds_list_create()
instance_place_list(x, y, obj_block_custom, blocks, false)
init_terrain()
radius = max(width, height)



//// tiles
tm_w = width + 2
tm_h = height + 2
tile_map_id = layer_tilemap_create("tiles",
									x0 - global.grid_size * 0.5,
									y0 - global.grid_size * 0.5,
									ts_planet_ground,
									tm_w,
									tm_h)
tile_map_resources_id = layer_tilemap_create("tiles_resources",
											x0 - global.grid_size,
											y0 - global.grid_size,
											ts_planet_resources,
											tm_w,
											tm_h)
//// bgr tiles
var bgr_tile_size = 16
var bgr_w = global.grid_size / bgr_tile_size * tm_w
var bgr_h = global.grid_size / bgr_tile_size * tm_h
bgr_w = floor(bgr_w)
bgr_h = floor(bgr_h)
var bgr_mesh = perlin_mesh(bgr_w, bgr_h, perlin_grads_cell_size, perlin_grads_cell_size)
var farbgr_w = bgr_w - 1
var farbgr_h = bgr_h - 1
var farbgr_mesh = array2d(farbgr_w, farbgr_h, 1)
// zero edges
bgr_mesh[0] = array_create(bgr_h, 0)
bgr_mesh[bgr_w-1] = array_create(bgr_h, 0)
farbgr_mesh[0] = array_create(bgr_h, 0)
farbgr_mesh[farbgr_w-1] = array_create(farbgr_h, 0)
for (var i = 0; i < farbgr_w; ++i) {
    bgr_mesh[i][0] = 0
	bgr_mesh[i][bgr_h-1] = 0
	farbgr_mesh[i][0] = 0
	farbgr_mesh[i][farbgr_h-1] = 0
}

bgr_mesh = collapse_mesh_cells(bgr_mesh, 0.35)
autotiler_bgr = new Autotiling("tiles_bgr",
								x0,
								y0,
								ts_planet_ground_bgr,
								bgr_w-1,
								bgr_h-1,
								bgr_mesh,
								0)
autotiler_farbgr = new Autotiling("tiles_farbgr",
								x0 + bgr_tile_size * 0.5,
								y0 + bgr_tile_size * 0.5,
								ts_planet_ground_farbgr,
								farbgr_w-1,
								farbgr_h-1,
								farbgr_mesh,
								0)
draw_tiles()
autotiler_bgr.draw_region(0, 0, bgr_w - 1, bgr_h - 1)
autotiler_farbgr.draw_region(0, 0, farbgr_w - 1, farbgr_h - 1)
