
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

function chance(p) {
	return random(1) < p
}
