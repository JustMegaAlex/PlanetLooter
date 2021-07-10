
function perlin_mesh(w, h){
	var mesh = array2d(w, h, 0)
	var grads_w = w + 1
	var grads_h = h + 1
	var grads = array2d(grads_w, grads_h, noone)

	// fill gradients
	for (var i = 0; i < grads_w; ++i) {
	    for (var j = 0; j < grads_h; ++j) {
			// (-1, 1)
		    grads[i][j] = new Point(random(1) - 1, random(1) - 1)
		}
	}

	// compute mesh
	for (var i = 0; i < w; ++i) {
	    for (var j = 0; j < h; ++j) {
			var g00 = grads[i][j]
			var g01 = grads[i][j + 1]
			var g10 = grads[i + 1][j]
			var g11 = grads[i + 1][j + 1]
		    mesh[i][j] = compute_influence(g00, g01, g10, g11)
		}
	}
	mesh = normalize_mesh(mesh, 1)
	return mesh
}

function compute_influence(g00, g01, g10, g11) {
	// actually computes the value for a cell
	var f00 = g00.x_ * 0.5 + g00.y_ * 0.5
	var f01 = g01.x_ * 0.5 - g01.y_ * 0.5
	var f10 = -g10.x_ * 0.5 + g10.y_ * 0.5
	var f11 = -g11.x_ * 0.5 - g11.y_ * 0.5
	var res = (f00 + f10 + f01 + f11) * 0.25
	return res
}

function normalize_mesh(mesh, val) {
	var _max = -infinity
	var _min = infinity
	var w = array_length(mesh)
	var h = array_length(mesh[0])
	for (var i = 0; i < w; ++i) {
	    for (var j = 0; j < h; ++j) {
		    _max = max(mesh[i][j], _max)
			_min = min(mesh[i][j], _min)
		}
	}
	var gap = _max - _min
	var norm_coef = val / gap
	// ex: [0.1, 0.4] val = 1
	// _min = 0.1 _max = 0.4 gap = 0.3 norm_coef = 1/ 0.3 = 3.33333
	// 0.1 -> (0.1 - 0.1) * 0.33 = 0
	// 0.4 -> (0.4 - 0.1) * 0.33 = 1
	// 0.25 -> (0.25 - 0.1) * 0.33 = 0.15 * 0.33 = 0.495 = 0.5
	for (var i = 0; i < w; ++i) {
	    for (var j = 0; j < h; ++j) {
		    mesh[i][j] = (mesh[i][j] - _min) * norm_coef
		}
	}
	return mesh
}

function array2d(w, h, val) {
	var arr = array_create(w)
	for (var i = 0; i < w; ++i) {
	    arr[i] = array_create(h, val)
	}
	return arr
}