
global.arr_patrol_routes = []

function generate_patrol_route(first_planet) {
	function _planet_random_point(p) {
		return array_choose(planet_get_route_points(p))
	}

	var route = []
	var total_num = instance_number(obj_planet)
	var max_length = min(total_num,
					     global.ai_max_partol_route_length)
	if max_length < 2
		return []

	var planets_num = irandom_range(2, max_length)
	if first_planet != undefined {
		array_push(route, _planet_random_point(first_planet))
		planets_num--
	}
	var n = 0
	while planets_num {
		n = irandom(total_num - 1)
		var pl = instance_find(obj_planet, n)
		if array_find(route, pl) != -1
			continue
		planets_num--

		array_push(route, _planet_random_point(pl))
	}
	array_push(global.arr_patrol_routes, route)
	return route
}

function planet_get_route_points(planet) {
	var extra_dist = 100
	var rr = planet.radius + extra_dist
	var v_center = new Vec2d(planet.x, planet.y)
	var arr = []
	array_push(arr, v_center.add_coords(-rr, -rr))
	array_push(arr, v_center.add_coords_(rr, -rr))
	array_push(arr, v_center.add_coords_(-rr, rr))
	array_push(arr, v_center.add_coords_(rr, rr))
	return arr
}
