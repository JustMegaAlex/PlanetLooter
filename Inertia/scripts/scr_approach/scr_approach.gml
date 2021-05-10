///@arg var_value
///@arg approach_to
///@arg	speed
function scr_approach(from, to, sp) {
	delta = to - from
	if abs(delta) < sp
		return to
	return from + sp*sign(delta) 
}

function scr_chance(p) {
	return (random(1) < p)
}