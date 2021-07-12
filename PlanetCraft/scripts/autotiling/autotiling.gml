// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function Autotiling(layer, x_, y_, tileset, w, h, tile_grid, empty_tile_val) constructor {
	self.x_ = x_
	self.y_ = y_
	self.w = w
	self.h = h
	self.tilemap = layer_tilemap_create(layer, x_, y_, tileset, w, h)
	self.empty_tile = empty_tile_val
	self.tile_grid = tile_grid

	function draw_region(i, j, ni, nj) {
		for (var ii = i; ii< i + ni; ++ii) {
		    for (var jj = j; jj < j + nj; ++jj) {
				self._draw_tile(ii, jj, true)
			}
		}
	}

	function _draw_tile(i, j) {
		var tile_index = self.compute_tile_index(i, j)
		var tdata = tile_index | 0 | 0
		tilemap_set(self.tilemap, tdata, i, j)
	}

	function compute_tile_index(i, j) {
		return (mesh_tile_value(i, j)
				+ 2 * mesh_tile_value(i+1, j)
				+ 4 * mesh_tile_value(i, j+1)
				+ 8 * mesh_tile_value(i+1, j+1))
	}

	function mesh_tile_value(i, j) {
		return self.tile_grid[i][j] != self.empty_tile
	}

	function draw() {
		for (var i = 0; i < self.w; ++i) {
		    for (var j = 0; j < self.h; ++j) {
				self._draw_tile(i, j)
			}
		}
	}
}