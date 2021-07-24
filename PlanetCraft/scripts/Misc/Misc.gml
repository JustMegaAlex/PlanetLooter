
function value_between(val, min_, max_){
	return (val >= min_) and (val < max_)
}

function approach(val, to, ammount) {
	var delta = to - val
	if abs(delta) < ammount
		return to
	var sp = ammount * sign(delta) 
	return val + sp
}

function cycle_decrease(val, min_, max_) {
	val--
	var inboudns = val >= min_
	return val * inboudns + max_ * !inboudns
}

function array_sum(arr) {
	var res = 0
	for (var i = 0; i < array_length(resources); ++i) {
	    res += resources[i]
	}
	return res
}

function array_has(arr, val) {
	for (var i = 0; i < array_length(arr); ++i) {
	    if val == arr[i]
			return true
	}
	return false
}

function array_count(arr, val) {
	var count = 0
	for (var i = 0; i < array_length(arr); ++i) {
	    if val == arr[i]
			count++
	}
	return count
}

function array_find(arr, val) {
	for (var i = 0; i < array_length(arr); ++i) {
	    if val == arr[i]
			return i
	}
	return -1
}

function array_remove(arr, val) {
	var i = array_find(arr, val)
	if i == -1
		throw " :array_remove: no value in array: " + string(val)
	array_delete(arr, i, 1)
}

function array_choose(arr) {
	var ind = irandom(array_length(arr) - 1)
	return arr[irandom(array_length(arr) - 1)]
}

function cycle_increase(val, min_, max_) {
	val++
	var inboudns = val < max_
	return val * inboudns + min_ * !inboudns
}

function chance(p) {
	return random(1) < p
}

function draw_text_custom(xx, yy, text, font, halign, valign) {
	var prev_valign = draw_get_valign()	
	var prev_halign = draw_get_halign()
	var prev_font = draw_get_font()
	if !font
		font = prev_font
	if !halign
		halign = prev_halign
	if !valign
		valign = prev_valign
	draw_set_font(font)
	draw_set_halign(halign)
	draw_set_valign(valign)
	draw_text(xx, yy, text)
	draw_set_font(prev_font)
	draw_set_halign(prev_halign)
	draw_set_valign(prev_valign)
}

function inst_mouse_dir(inst) {
	return point_direction(inst.x, inst.y, mouse_x, mouse_y)
}

function inst_inst_dir(inst, inst_to) {
	return point_direction(inst.x, inst.y, inst_to.x, inst_to.y)
}

function inst_inst_dist(inst, inst_to) {
	return point_distance(inst.x, inst.y, inst_to.x, inst_to.y)
}

function mouse_dir() {
	return point_direction(id.x, id.y, mouse_x, mouse_y)
}

function inst_dir(inst_to) {
	return point_direction(id.x, id.y, inst_to.x, inst_to.y)
}

function inst_dist(inst_to) {
	return point_distance(id.x, id.y, inst_to.x, inst_to.y)
}

function point_dist(xx, yy) {
	return point_distance(id.x, id.y, xx, yy)
}

function point_dir(xx, yy) {
	return point_direction(id.x, id.y, xx, yy)
}
