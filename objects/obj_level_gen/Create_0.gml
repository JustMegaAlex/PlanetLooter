
function Node(xx, yy, nodes) constructor {
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
	var blocks_num = random_range(0.5, 1) * blocks_max_num
	while instance_number(obj_block) < blocks_num {
		var size = irandom_range(5, 30)
		create_planet_at_random_pos(size, true)
	}
	var level = min(global.level, array_length(enemies_progression) - 1)
	var enemies_set = enemies_progression[level]
	create_enemies(enemies_set)

	level = min(global.level, array_length(buildings_progression) - 1)
	var buildings_set = buildings_progression[level]
	create_buildings(buildings_set)
	
	instance_destroy(obj_planet_mask)
}

function generate_star_system_1 () {
	generate_star_system_graph()
	var xmin = infinity
	var ymin = infinity
	var xmax = -infinity
	var ymax = -infinity
	for (var i = 0; i < array_length(nodes); ++i) {
		var n = nodes[i]
	    var size = irandom_range(planet_min_size, planet_max_size)
		create_planet_coord(n.X, n.Y, size, true)
		xmin = min(n.X, xmin)
		xmax = max(n.X, xmax)
		ymin = min(n.Y, ymin)
		ymax = max(n.Y, ymax)
	}
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

	var first = new Node(0, 0)
	var dir = random(360)
	var dist = max_planet_dist * random_range(0.7, 1)
	var xx = first.X + lengthdir_x(dist, dir)
	var yy = first.Y + lengthdir_y(dist, dir)
	var second = new Node(xx, yy, [first])
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
					var n = new Node(xx, yy, [root])
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

function create_planet_at_random_pos(size, bgr) {
	var r = irandom_range(rmin, rmax)
	var angle = random(360)
	var mask = get_planet_collision(r, angle, size)
	while mask.collided {
		instance_destroy(mask)
		r = irandom_range(rmin, rmax)
		angle = random(360)
		mask = get_planet_collision(r, angle, size)
	}
	create_planet(r, angle, size, bgr)
}

function create_planet(r, angle, bgr) {
	global._level_gen_planet_size = size
	global._level_gen_planet_background = bgr
	var xx = lengthdir_x(r, angle)
	var yy = lengthdir_y(r, angle)
	instance_create_layer(xx, yy, "Instances", obj_planet)
}

function create_planet_coord(xx, yy, size, bgr) {
	global._level_gen_planet_size = size
	global._level_gen_planet_background = bgr
	instance_create_layer(xx, yy, "Instances", obj_planet)
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

function create_enemies(set) {
	var groups_distribution = set[0]
	var forposts = set[1]
	var alert_tower_num = 2
	for (var i = 0; i < array_length(groups_distribution); ++i) {
	    var num = i + 1
		var planet = choose_planet()
		var patrol_route = generate_patrol_route(planet)
		var dist = planet.radius + 100
		var angle = random(360)
		var xx = planet.x + lengthdir_x(dist, angle)
		var yy = planet.y + lengthdir_y(dist, angle)
		var ships = []
		repeat (num) {
			if chance(0.25)
				instance_create_args(0, 0, "Instances", obj_turret, {planet: planet})
			else {
				var is_patrol = chance(0.3)
				var ship = instance_create_args(xx+random(100), yy+random(100),
									 "Instances", obj_enemy, 
									 {is_patrol: is_patrol, patrol_route: patrol_route})
				array_push(ships, ship)
			}
		}
		if alert_tower_num--
			instance_create_args(xx, yy, "Instances", obj_alert_tower, {arr_ships: ships})
		if (num >= (forpost_min_group_size + global.level)) and forposts-- {
			with instance_create_layer(0, 0, "Instances", obj_production_module) {self.planet = planet}
		}
	}
}

function _create_enemy_group(xx, yy, num) {
	
}

function create_buildings(set) {
	var buildings_set = set[0]
	var controlled_number = set[1]
	var plants = buildings_set[0]
	var manufs = buildings_set[1]
	var yards = buildings_set[2]

	var buildings = []
	var controlled_buildings = []
	repeat (plants)
		array_push(buildings, instance_create_layer(0, 0, "Instances", obj_building_plant))
	repeat (manufs)
		array_push(buildings, instance_create_layer(0, 0, "Instances", obj_building_manufacture))
	repeat (yards)
		array_push(buildings, instance_create_layer(0, 0, "Instances", obj_building_shipyard))
}

blocks_max_num = 2500
rmax = 10000
rmin = 800

planet_min_size = 10
planet_max_size = 15
max_planet_dist = 1600
min_planet_number = 3
max_planet_number = 6

forpost_min_group_size = 3

enemies_progression = [
	// groups, [min_group_size, max_group_size], forposts
	//[7, [2, 3]], 0,
	// [[<1-sized groups>, <2-sized groups>, ..., <n-sized groups>], forposts]
	//1   2   3   4   5   6   7   8   9  10
	[[3,  2,  2,  0,  0,  0], 1],
	[[0,  3,  3,  1,  0,  0,  0,  2], 1],
	[[0,  8, 0,  4,  1,  0,  0,  0,  0,  5],  3],
	[[0,  0,  0,  0,  5,  4,  2,  0,  0, 10],  6],
	[[0],  1],
]

buildings_progression = [
	// [plants, manufs, yards], controlled_buildings
	[[1, 1, 1], 1], 
	[[3, 1, 1], 2],
	[[4, 3, 2], 5],
	[[5, 5, 3], 10],
	[[7, 7, 4], 14],
]


