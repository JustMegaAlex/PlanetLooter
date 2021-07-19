
function generate_star_system() {
	var blocks_num = random_range(0.5, 1) * blocks_max_num
	while instance_number(obj_block) < blocks_num {
		var size = irandom_range(5, 30)
		create_planet_at_random_pos(size)
	}
	var level = min(global.level, array_length(enemies_progression) - 1)
	var enemies_set = enemies_progression[level]
	create_enemies(enemies_set)
	
	level = min(global.level, array_length(buildings_progression) - 1)
	var buildings_set = buildings_progression[level]
	create_buildings(buildings_set)
	
	instance_destroy(obj_planet_mask)
}

function create_planet_at_random_pos(size) {
	var r = irandom_range(rmin, rmax)
	var angle = random(360)
	var mask = get_planet_collision(r, angle, size)
	while mask.collided {
		instance_destroy(mask)
		r = irandom_range(rmin, rmax)
		angle = random(360)
		mask = get_planet_collision(r, angle, size)
	}
	create_planet(r, angle, size)
}

function create_planet(r, angle, size) {
	global._level_gen_planet_size = size
	var xx = lengthdir_x(r, angle)
	var yy = lengthdir_y(r, angle)
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

enemies_progression = [
	// groups, [min_group_size, max_group_size]
	[8, [2, 3]],
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


