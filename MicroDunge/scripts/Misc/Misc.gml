
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

function array_find(arr, val) {
	for (var i = 0; i < array_length(arr); ++i) {
	    if arr[i] == val
			return i
	}
	return -1
}

function array_remove(arr, val) {
	var i = array_find(arr, val)
	if i == -1
		throw (" :array_remove: value is not in array")
	array_delete(arr, i, 1)
}
