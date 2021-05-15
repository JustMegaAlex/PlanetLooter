///@arg var_value
///@arg approach_to
///@arg	speed
function scr_approach(argument0, argument1, argument2) {
	delta = argument1 - argument0

	if abs(delta) < argument2
		return argument1
	
	var sp = argument2*sign(delta) 

	return argument0 + sp


}
