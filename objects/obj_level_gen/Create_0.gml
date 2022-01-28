
function SectorNode(xx, yy, nodes) constructor {
	self.X = xx
	self.Y = yy
	self.nodes = []
	if nodes != undefined
		self.nodes = nodes

	dist = function(node) {
		return point_distance(self.X, self.Y, node.X, node.Y)	
	}

	dir = function(node) {
		return point_direction(self.X, self.Y, node.X, node.Y)	
	}
}

function generate_star_system() {
	generate_star_system_graph()
	var xmin = infinity
	var ymin = infinity
	var xmax = -infinity
	var ymax = -infinity
	var planets = []
	for (var i = 0; i < array_length(nodes); ++i) {
		var n = nodes[i]
	    var size = irandom_range(planet_min_size, planet_max_size)
		var pl = create_planet_coord(n.X, n.Y, size, true)
		array_push(planets, pl)
		xmin = min(n.X, xmin)
		xmax = max(n.X, xmax)
		ymin = min(n.Y, ymin)
		ymax = max(n.Y, ymax)
	}
	global.astar_graph = new AstarGraph()
	setup_path_finding_graph(global.astar_graph, planets)
	//generate_asteroids(xmin, ymin, xmax, ymax)
	level = min(global.level, array_length(buildings_progression) - 1)
	var buildings_set = buildings_progression[level]
	// enemies
	var level = min(global.level, array_length(enemies_progression) - 1)
	var enemies_set = enemies_progression[level]
	if global.gen_create_enemies
		create_enemies(enemies_set)
}

function generate_star_system_graph() {
	var axis_dir = random(360)
	var planet_number = irandom_range(min_planet_number, max_planet_number)
	var axis_num = floor(planet_number * 0.65)
	var leafs_num = planet_number - axis_num

	var first = new SectorNode(0, 0)
	var dir = random(360)
	var dist = max_planet_dist * random_range(0.7, 1)
	var xx = first.X + lengthdir_x(dist, dir)
	var yy = first.Y + lengthdir_y(dist, dir)
	var second = new SectorNode(xx, yy, [first])
	first.nodes = [first]
	nodes = [first, second]
	leafs = []
	var prev = nodes[0]
	for (var i = 1; i < planet_number; i++) {
		var added = true
		repeat 100 {
			var root = array_choose(nodes)
			var steps = array_length(nodes)
			for (var step = 0; step < steps; ++step) {
				root = array_choose(root.nodes)
			}
			repeat 100 {
				var dir = random(360)
				var dist = max_planet_dist * random_range(0.7, 1)
				var xx = root.X + lengthdir_x(dist, dir)
				var yy = root.Y + lengthdir_y(dist, dir)
				for (var ii = 0; ii < array_length(nodes); ++ii) {
				    var check = nodes[ii]
					if point_distance(check.X, check.Y, xx, yy) < (dist - 1) {
						added = false
						break
					}
				}
				if added {
					var n = new SectorNode(xx, yy, [root])
					array_push(nodes, n)
					array_push(root.nodes, n)
					break
				}
			}
			if added { break }
		}
	}
	return nodes
}

function generate_asteroids(x0, y0, x1, y1) {
	repeat(200) {
		var xx = random_range(x0, x1)
		var yy = random_range(y0, y1)
		var size = irandom_range(2, 5)
		var mask = get_planet_collision_coord(xx, yy, size)
		if !mask.collided
			create_planet_coord(xx, yy, size, false)
	}
}

function create_planet_coord(xx, yy, size, bgr) {
	return instance_create_args(xx, yy, "Instances", obj_planet,
						 {size: size, bgr: bgr})
}

function get_planet_collision(r, angle, size) {
	var xx = lengthdir_x(r, angle)
	var yy = lengthdir_y(r, angle)
	var mask = instance_create_layer(xx, yy, "Instances", obj_planet_mask)
	with mask {
		self.image_xscale = size
		self.image_yscale = size
		self.collided = place_meeting(x, y, obj_planet_mask)
	}
	return mask
}

function get_planet_collision_coord(xx, yy, size) {
	var mask = instance_create_layer(xx, yy, "Instances", obj_planet_mask)
	with mask {
		self.image_xscale = size
		self.image_yscale = size
		self.collided = place_meeting(x, y, obj_planet_mask)
	}
	return mask
}

function create_ships_group(xx, yy, number, is_patrol, patrol_route) {
	repeat(number) {
		var ship = instance_create_args(xx+random(100), yy+random(100),
								"Instances", obj_enemy, 
								{is_patrol: is_patrol, patrol_route: patrol_route})
	}
}

function get_random_point_arount_planet(planet) {
	var dist = planet.radius + 100
	var angle = random(360)
	var xx = planet.x + lengthdir_x(dist, angle)
	var yy = planet.y + lengthdir_y(dist, angle)
	return new Vec2d(xx, yy)
}

function create_enemies(set) {
	var groups_distribution = set.ships_distr
	for (var i = 0; i < array_length(groups_distribution); ++i) {
		var groups_num = groups_distribution[i]
	    var group_size = i + 1
		repeat (groups_num) {
			var planet = choose_planet()
			var patrol_route = generate_patrol_route(planet)
			var p = get_random_point_arount_planet(planet)
			var is_patrol = chance(spawn_is_patrol_chance)
			create_ships_group(p.X, p.Y, group_size, is_patrol, patrol_route)	
		}
	}

	// forposts
	var forposts = set.forposts
	for (var i = 0; i < array_length(forposts); ++i) {
	    var forpost_power = forposts[i]
		var turrets_number = floor(forpost_power * spawn_forpost_turret_fract)
		var ships_number = forpost_power - turrets_number
		
		var planet = choose_planet()
		var p = get_random_point_arount_planet(planet)
		create_ships_group(p.X, p.Y, ships_number, false, undefined)
		repeat turrets_number
			instance_create_args(0, 0, "Instances", obj_turret, {planet: planet, place_close_to_point: p})
	}
}

function setup_path_finding_graph(graph_struct, planets) {
	function _add_inner_node(i, j, size, points) {
		function _add_link(node, i, j, points) {
			var lnk_point = points[i, j]
			if collision_line(node.point.X, node.point.Y, lnk_point.X, lnk_point.Y, obj_block, false, false)
				return false
			var lnk_name = point_to_name(lnk_point)
			var lnk = global.astar_graph.get_or_create(lnk_name, lnk_point)
			node.add_link(lnk)
			return true
		}

		var p = points[i][j]
		var name = point_to_name(p)
		var node = global.astar_graph.get_or_create(name, p)
		if (i > 0)
			_add_link(node, i-1, j, points)
		if (i < (size - 1))
			_add_link(node, i+1, j, points)
		if (j > 0)
			_add_link(node, i, j-1, points)
		if (j < (size - 1))
			_add_link(node, i, j+1, points)
	}
	// interplanetary graph
	var it = new IterArray(planets)
	var points = []
	while it.next() != undefined {
		array_expand(points, planet_get_route_points(it.get()))
	}
	var num = array_length(points)
	var p, p1
	for (var i = 0; i < num - 1; ++i) {
		p = points[i]
		var link_points = {}
	    for (var j = i + 1; j < num; ++j) {
		    p1 = points[j]
			if !collision_line_width(p.X, p.Y, p1.X, p1.Y,
							   obj_planet_mask, global.path_finding_graph_collison_line_width).inst
				variable_struct_set(link_points, point_to_name(p1), p1)
				
		}
		graph_struct.add_node_from_point(p, link_points)
	}

	// innerplanetary graph
	it.reset()
	while it.next() {
		// init points
		var pl = it.get()
		var x0 = pl.left_coord()
		var y0 = pl.top_coord()
		var size = pl.size
		var points = []
		for (var i = 0; i < size; ++i) {
		    var row = []
			points[i] = row
			var xx = x0 + (i+0.5) * global.grid_size
			for (var j = 0; j < size; ++j) {
				var yy = y0 + (j+0.5) * global.grid_size
			    row[j] = new Vec2d(xx, yy)
			}
		}
		// add nodes
		for (var i = 0; i < size; ++i) {
			for(var j = 0; j < size; ++j) {
				_add_inner_node(i, j, size, points)
			}
		}
	}
}

blocks_max_num = 2500
rmax = 10000
rmin = 800

planet_min_size = global.gen_planet_min_size
planet_max_size = global.gen_planet_max_size
max_planet_dist = global.gen_max_planet_dist
min_planet_number = global.gen_min_planet_number
max_planet_number = global.gen_max_planet_number
spawn_is_patrol_chance = global.gen_spawn_is_patrol_chance
spawn_forpost_turret_fract = global.gen_spawn_forpost_turret_fract

forpost_min_group_size = 3

enemies_progression = [
	// groups, [min_group_size, max_group_size], forposts
	//[7, [2, 3]], 0,
	// [[<1-sized groups>, <2-sized groups>, ..., <n-sized groups>], forposts]
				 //1   2   3   4   5   6   7   8   9  10
	{ships_distr: [3,  2,  2,  0,  0,  0], forposts: [10]},
	{ships_distr: [0,  3,  3,  1,  0,  0,  0,  2], forposts: 2, alert_towers: 3},
	{ships_distr: [0,  8,  0,  4,  1,  0,  0,  0,  0,  5], forposts: 4, alert_towers: 4},
	{ships_distr: [0,  0,  0,  0,  5,  4,  2,  0,  0, 10], forposts: 4, alert_towers: 4},
]
if global.gen_setup_mobs_override != undefined
	array_insert(enemies_progression, 0, global.gen_setup_mobs_override)

buildings_progression = [
	// [plants, manufs, yards], controlled_buildings
	[[1, 1, 1], 1], 
	[[3, 1, 1], 2],
	[[4, 3, 2], 5],
	[[5, 5, 3], 10],
	[[7, 7, 4], 14],
]

level_seed  = 0
