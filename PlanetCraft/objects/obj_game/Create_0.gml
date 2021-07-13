scr_debug_ini()
global.DEBUG = true

function generate_star_system() {
	var blocks_num = random_range(0.5, 1) * blocks_max_num
	while instance_number(obj_block) < blocks_num {
		var size = irandom_range(5, 30)
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
	var enemies, buildings
	if level >= array_length(enemies_progression)
		enemies = enemies_progression[array_length(enemies_progression) - 1]
	else
		enemies = enemies_progression[level]
	var groups = enemies[0]
	var min_ = enemies[1][0]
	var max_= enemies[1][1]
	
	repeat (groups) {
		var num = irandom_range(min_, max_)
		var planet = choose_planet()
		var dist = planet.radius + 100
		var angle = random(360)
		var xx = planet.x + lengthdir_x(dist, angle)
		var yy = planet.y + lengthdir_y(dist, angle)
		repeat (num) instance_create_layer(xx+random(100), yy+random(100), "Instances", obj_enemy)
	}
	

	if level >= array_length(buildings_progression)
		buildings = buildings_progression[array_length(buildings_progression) - 1]
	else
		buildings = buildings_progression[level]
	var plants = buildings[0]
	var manufs = buildings[1]
	var yards = buildings[2]
	repeat (plants) instance_create_layer(0, 0, "Instances", obj_building_plant)
	repeat (manufs) instance_create_layer(0, 0, "Instances", obj_building_manufacture)
	repeat (yards) instance_create_layer(0, 0, "Instances", obj_building_shipyard)
	
	instance_destroy(obj_planet_mask)
}

function create_planet(r, angle, size) {
	var xx = lengthdir_x(r, angle)
	var yy = lengthdir_y(r, angle)
	with instance_create_layer(xx, yy, "Instances", obj_planet) {
		self.size = size
	}
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

enum Sides {
	ours,
	theirs,
	neutral,
}

global.ui_interface_on = false
global.game_over = false
draw_set_font(fnt)
level = 0
blocks_max_num = 2500
planet_min_blocks = 16
rmax = 10000
rmin = 800

enemies_progression = [
	// groups, [min_group_size, max_group_size]
	[15, [2, 3]],
	[17, [3, 4]],
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

show_tips = false
tips_text = "WASD to move\nMouse to shoot\nE to interact with buidlings\nWhen you have 10 fuel hold space to warp\nR to restart"
tips_text += "compass arrows point to planets"
tips_header = "Press T to show tips"
