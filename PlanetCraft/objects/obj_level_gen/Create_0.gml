
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
	var level = min(global.level, array_length(enemies_progression) - 1)
	var enemies_set = enemies_progression[level]
	create_enemies(enemies_set)

	level = min(global.level, array_length(buildings_progression) - 1)
	var buildings_set = buildings_progression[level]
	create_buildings(buildings_set)
	
	instance_destroy(obj_planet_mask)
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
		if array_has(nodes, 0)
			test = true
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
					if array_has(nodes, 0)
						test = true
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
	var groups = set[0]
	var min_ = set[1][0]
	var max_= set[1][1]

	repeat (groups) {
		var num = irandom_range(min_, max_)
		var planet = choose_planet()
		var dist = planet.radius + 100
		var angle = random(360)
		var xx = planet.x + lengthdir_x(dist, angle)
		var yy = planet.y + lengthdir_y(dist, angle)
		repeat (num) instance_create_layer(xx+random(100), yy+random(100), "Instances", obj_enemy)
	}

}

function create_buildings(set) {
	var plants = set[0]
	var manufs = set[1]
	var yards = set[2]
	repeat (plants) instance_create_layer(0, 0, "Instances", obj_building_plant)
	repeat (manufs) instance_create_layer(0, 0, "Instances", obj_building_manufacture)
	repeat (yards) instance_create_layer(0, 0, "Instances", obj_building_shipyard)
}

blocks_max_num = 2500
rmax = 10000
rmin = 800

planet_min_size = 15
planet_max_size = 30
max_planet_dist = 5000
min_planet_number = 5
max_planet_number = 12


enemies_progression = [
	// groups, [min_group_size, max_group_size]
	[0, [2, 3]],
	[12, [3, 4]],
	[22, [5, 7]],
	[26, [5, 12]],
	[32, [8, 20]],
]

buildings_progression = [
	// plants, manufs, yards
	[1, 1, 1],
	[3, 1, 1],
	[4, 3, 2],
	[5, 5, 3],
	[7, 7, 4],
]


