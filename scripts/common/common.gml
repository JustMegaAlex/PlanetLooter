
global.arr_patrol_routes = []


AIVelocity = {
	scan_radius_max: 80,
	scan_radius: 0,
	affectors: ds_list_create(),
	resulting_vector: new Vec2d(0, 0),

	update_velocity_avoid_obstacles: function(vel, pos, sp_max, avoid_obj) {
		var scan_center = self.get_scan_center(pos, vel)
		scan_radius = vel.len() / sp_max * scan_radius_max
		collision_circle_list(
			scan_center.X, scan_center.Y,
			self.scan_radius, avoid_obj, false,
			true, affectors, false)
		for(i = 0; i < ds_list_size(affectors); ++i) {
			var inst = affectors[| i]
			var dist = min(scan_radius, point_distance(pos.X, pos.Y, inst.x, inst.y))
			var rel_dist = (scan_radius - dist) / scan_radius
			var dir = point_direction(pos.X, pos.Y, inst.x, inst.y) + 180
			var add = rel_dist * rel_dist * sp_max;
			vel.add_polar(add, dir)
		}
	},

	ray_scanners_config: [
		{len: 80, angle: 10, gain: 1},
		{len: 80, angle: -10, gain: 1},
		{len: 60, angle: 30, gain: 0.7},
		{len: 60, angle: -30, gain: 0.7},
		{len: 50, angle: 45, gain: 0.7},
		{len: 50, angle: -45, gain: 0.7},
		{len: 50, angle: 60, gain: 0.7},
		{len: 40, angle: -60, gain: 0.7},

		{len: 30, angle: 90, gain: 0.6},
		{len: 30, angle: 120, gain: 0.6},
		{len: 30, angle: -90, gain: 0.6},
		{len: 30, angle: -120, gain: 0.6},
	],
	ray_scanners: [],
	update_velocity_avoid_obstacles_v2: function(vel, pos, dir, sp_max, avoid_obj) {
		var iter = new IterArray(self.ray_scanners_config)
		self.ray_scanners = []
		self.resulting_vector.set(0, 0)
		while iter.next() {
			var conf = iter.get()
			var p2 = pos.add_polar_(conf.len, dir + conf.angle)
			var line = new Line(pos.X, pos.Y, p2.X, p2.Y)
			var block = self.ray_scan(line, obj_block)
			array_push(self.ray_scanners,{positive: block != noone, line: line})
			if block {
				var dist = max(0, conf.len - point_distance(pos.X, pos.Y, block.x, block.y))
				var rel_dist = dist / conf.len
				var add = sp_max * conf.gain * rel_dist
				var add_dir = dir - 90 * sign(conf.angle)
				vel.add_polar(add, add_dir)
				resulting_vector.add_polar(add, add_dir)
			}
		}
	},

	get_scan_center: function(pos, vel) {
		return pos.add_polar_(scan_radius * 0.5, vel.dir())
	},
	
	ray_scan: function(line, obj) {
		var list = ds_list_create()
		collision_line_list(line.xst, line.yst, line.xend, line.yend,
							obj, false, false, list, false)
		if ds_list_empty(list)
			return noone
		var dist = infinity;
		var closest = noone;
		for(var i = 0; i < ds_list_size(list); i++) {
			var inst = list[| i]
			if point_distance(line.xst, line.yst, inst.x, inst.y) < dist
				closest = inst
		}
		return closest
	}
}



//// old

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
		if array_find_ind(route, pl) != -1
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
	var arr = [
		v_center.add_coords_(-rr, -rr),
		v_center.add_coords_(rr, -rr),
		v_center.add_coords_(-rr, rr),
	]
	array_push(arr, v_center.add_coords(rr, rr))
	return arr
}
