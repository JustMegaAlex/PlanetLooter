
global.arr_patrol_routes = []

function generate_patrol_route(first_planet) {
	var planets = []
	var total_num = instance_number(obj_planet)
	var max_length = min(total_num,
					     global.ai_max_partol_route_length)
	if max_length < 2
		return []

	var planets_num = irandom_range(2, max_length)
	if first_planet != undefined {
		array_push(planets, first_planet)
		planets_num--
	}
	var n = 0
	while planets_num {
		n = irandom(total_num - 1)
		var pl = instance_find(obj_planet, n)
		if array_find(planets, pl) != -1
			continue
		planets_num--
		array_push(planets, pl)
	}
	array_push(global.arr_patrol_routes, planets)
	return planets
}

function planet_get_route_points(planet) {
	var extra_dist = 100
	var rr = planet.radius + extra_dist
	var v_center = new Vec2d(planet.x, planet.y)
	var arr = [
		v_center.add_coords_(rr, rr),
		v_center.add_coords_(rr, -rr),
		v_center.add_coords_(-rr, rr),
	]
	array_push(arr, v_center.add_coords(-rr, -rr))
	return arr
}
