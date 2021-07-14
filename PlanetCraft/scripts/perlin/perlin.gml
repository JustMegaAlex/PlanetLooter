
function perlin_mesh(w, h, grad_cell_w, grad_cell_h){
	// w, h - result mesh sizes
	// grad_cell_w, grad_cell_h - number of result cells per one gradient cell
	var mesh = array2d(w, h, 0)
	var grads_w = w div grad_cell_w + 2
	var grads_h = h div grad_cell_h + 2
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
			var gradi = i div grad_cell_w
			var gradj = j div grad_cell_h
			var g00 = grads[gradi][gradj]
			var g01 = grads[gradi][gradj + 1]
			var g10 = grads[gradi + 1][gradj]
			var g11 = grads[gradi + 1][gradj + 1]
			var ifract = (i mod grad_cell_w) / grad_cell_w
			var jfract = (j mod grad_cell_h) / grad_cell_h
		    mesh[i][j] = compute_influence(ifract, jfract, g00, g01, g10, g11)
		}
	}
	mesh = normalize_mesh(mesh, 1)
	return mesh
}

function compute_influence(ifract, jfract, g00, g01, g10, g11) {
	// actually computes the value for a cell
	var f00 = g00.x_ * ease(ifract) + g00.y_ * ease(jfract)
	var f01 = g01.x_ * ease(1-ifract) - g01.y_ * ease(jfract)
	var f10 = g10.x_ * ifract + g10.y_ * ease(1-jfract)
	var f11 = g11.x_ * ease(1-ifract) - g11.y_ * ease(1-jfract)
	var res = (f00 + f10 + f01 + f11) * 0.25
	return res
}

function ease(arg) {
	return  3 * arg * arg - 2 * arg * arg * arg
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