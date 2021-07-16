
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
