
function choose_planet() {
	var num = instance_number(obj_planet)
	var planet = instance_find(obj_planet, irandom(num - 1))
	return planet
}