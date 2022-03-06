
// room_resta
function reset_globals() {
	global.arr_patrol_routes = []
	global.astar_graph.clear()
}

#macro Default:MODE "default"
#macro TestPathFinding:MODE "test_path_finding"
#macro GodMode:MODE "god_mode"
#macro Custom:MODE "custom"
#macro TestStuff:MODE "custom"
#macro TEST_PATH_FIND (MODE == "test_path_finding")
#macro TestPathFinding:START_ROOM rm_game
#macro GodMode:START_ROOM rm_game
#macro Custom:START_ROOM rm_game
#macro Default:START_ROOM rm_game
#macro TestStuff:START_ROOM rm_game_test

// debug
global.DEBUG = true
global.ai_attack_off = false
global.ai_show_move_routes = false
global.enable_instant_planet_move = true
global.enable_change_fps = true
global.player_immortal = false
global.no_damage = false
global.show_planets_data = false
global.show_ai_patrol_routes = false
global.show_alert_tower_stuff = true
global.show_path_finding_graph = false
global.debug_test_path_finding = false

// settings
global.ai_max_partol_route_length = 4
global.ai_rebel_block_extra_dist = 1
global.ai_mobs_look_for_collectibles_radius = 80
global.path_finding_graph_collison_line_width = 30
global.enemy_attack_formation_snipers_fract = 0.5
global.gen_create_enemies = true
global.gen_create_planets = true
global.gen_planet_min_size = 10
global.gen_planet_max_size = 15
global.gen_max_planet_dist = 1000
global.gen_min_planet_number = 6
global.gen_max_planet_number = 8
global.gen_spawn_is_patrol_chance = 0.45
global.gen_spawn_forpost_turret_fract = 0.5
global.gen_setup_mobs_override = undefined
global.start_resources_amount = 0
global.start_cargo_space = 100
global.view_to_window_ratio = 0.6

switch MODE {
	case "test_path_finding": {
		global.show_path_finding_graph = true
		global.gen_planet_min_size = 5
		global.gen_planet_max_size = 5
		global.gen_max_planet_dist = 1000
		global.gen_spawn_is_patrol_chance = 1
		global.gen_spawn_turret_chance = 0
		break
	}
	case "god_mode": {
		global.ai_attack_off = true
		global.player_immortal = true
		global.enable_instant_planet_move = true
		global.enable_change_fps = true
		global.show_ai_patrol_routes = true
		global.show_alert_tower_stuff = true
		break	
	}
	case "custom": {
		global.show_alert_tower_stuff = false
		global.enable_instant_planet_move = false
		global.player_immortal = true
		global.enemy_attack_formation_snipers_fract = 0.5
		global.debug_test_path_finding = true
		global.show_path_finding_graph = true
		//global.show_ai_patrol_routes = true
		//global.ai_attack_off = true

		//global.ai_max_patrol_route_length = 10
		global.gen_create_planets = true
		global.gen_min_planet_number = 6
		global.gen_max_planet_number = 6
		global.ai_show_move_routes = true
		global.show_planets_data = false

		global.gen_spawn_is_patrol_chance = 0
		global.gen_spawn_turret_chance = 0
		global.gen_spawn_forpost_turret_fract = 1
		global.gen_setup_mobs_override = {ships_distr: [0], forposts: [0]}

		global.start_resources_amount = 10
		global.start_cargo_space = 200
	}
}

// objects
global.astar_graph = noone
global.astar_graph_inner = noone
