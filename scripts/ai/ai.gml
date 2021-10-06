
global.arr_patrol_routes = []

function generate_patrol_route(first_planet) {
	var planets = []
	var planets_num = min(3, instance_number(obj_planet))
	if first_planet != undefined {
		array_push(planets, first_planet)
		planets_num--
	}
	var n = 0
	repeat planets_num {
		var pl = instance_find(obj_planet, n)
		if pl == first_planet
			continue
		array_push(planets, pl)
		n++
	}
	array_push(global.arr_patrol_routes, planets)
	return planets
}

function planet_get_patrol_points(planet) {
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
