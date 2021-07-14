
function move_to_planet(num) {
	if not global.DEBUG
		return 0
	var planet = instance_find(obj_planet, num)
	obj_looter.x = planet.x
	obj_looter.y = planet.y
}

current_planet = 0

show_planets_data = false
