
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

function _choose_route_point(p, route_points, obstacle_obj) {
	var dist = infinity
	var chosen = noone
	for (var i = 0; i < array_length(route_points); ++i) {
	    var rp = route_points[i]
		if !collision_line(p.X, p.Y, rp.X, rp.Y, obstacle_obj, false, true) {
			var _dist = point_distance(p.X, p.Y, rp.X, rp.Y)
			if _dist < dist {
				chosen = rp
				dist = _dist
			}
		}
	}
	return chosen
}

function find_farest_obstacle(pst, pend, obstacle_obj) {
	var obstacles_list = ds_list_create()
	collision_line_list(pst.Y, pst.Y, pend.Y, 
						pend.Y, obstacle_obj, false, true,
						obstacles_list, false)
	var dist = infinity
	var chosen = noone
	for (var i = 0; i < ds_list_size(obstacles_list); ++i) {
		var obst = obstacles_list[| i]
		var _dist = point_distance(pend.X, pend.Y, obst.x, obst.y)
		if _dist < dist {
			chosen = obst
			dist = _dist
		}
	}
	ds_list_destroy(obstacles_list)
	return chosen
}

function find_route(point_st, point_end, obstacle_obj=obj_planet_mask) {
	// closest to point_end (in fact same as for point_st)
	var obstacle = find_farest_obstacle(point_st, point_end, obstacle_obj)
	if obstacle != noone {
		obstacle = obstacle.planet_inst
		var obst_route_points = planet_get_route_points(obstacle)
		while array_length(obst_route_points) {
			var chosen_point = _choose_route_point(point_end, obst_route_points, obstacle_obj)
			if chosen_point == noone
				break
			var route = find_route(point_st, chosen_point, obstacle_obj)
			if array_length(route) != 0 {
				array_push(route, point_end)
				return route
			}
			array_remove(obst_route_points, chosen_point)
		}
		return []
	}
	return [point_st, point_end]
}
