
// room_reset
function reset_globals() {
	arr_patrol_routes = []
	astar_graph.clear()
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
DEBUG = false
ai_attack_off = false
ai_show_move_routes = false
enable_instant_planet_move = true
enable_change_fps = true
player_immortal = false
no_damage = false
show_planets_data = false
show_ai_patrol_routes = false
show_alert_tower_stuff = true
show_path_finding_graph = false
debug_test_path_finding = false

// settings
ai_max_partol_route_length = 4
ai_rebel_block_extra_dist = 1
ai_mobs_look_for_collectibles_radius = 80
ai_mobs_reach_point_treshold = grid_size
path_finding_graph_collison_line_width = 30
enemy_attack_formation_snipers_fract = 0
enemy_collisions_on = false
weapon_base_sp = 10
weapon_phase2_sp = 6
weapon_spread_reload_time = 7
gen_create_enemies = false
gen_create_planets = true
gen_optimize_astar_graph = true
gen_planet_min_size = 10
gen_planet_max_size = 15
gen_max_planet_dist = 1000
gen_min_planet_number = 6
gen_max_planet_number = 8
gen_spawn_is_patrol_chance = 0
gen_spawn_forpost_turret_fract = 0.5
gen_setup_mobs_override = undefined
start_resources_amount = 2
start_cargo_space = 100
view_to_window_ratio = 0.6

switch MODE {
	case "test_path_finding": {
		show_path_finding_graph = true
		gen_planet_min_size = 5
		gen_planet_max_size = 5
		gen_max_planet_dist = 1000
		gen_spawn_is_patrol_chance = 1
		gen_spawn_turret_chance = 0
		break
	}
	case "god_mode": {
		ai_attack_off = true
		player_immortal = true
		enable_instant_planet_move = true
		enable_change_fps = true
		show_ai_patrol_routes = true
		show_alert_tower_stuff = true
		break	
	}
	case "custom": {
		show_alert_tower_stuff = false
		enable_instant_planet_move = false
		player_immortal = true
		enemy_attack_formation_snipers_fract = 0
		debug_test_path_finding = false
		show_path_finding_graph = false
		enemy_collisions_on = true
		//show_ai_patrol_routes = true
		//ai_attack_off = true

		//ai_max_patrol_route_length = 10
		gen_create_planets = false
		gen_min_planet_number = 6
		gen_max_planet_number = 6
		ai_show_move_routes = true
		show_planets_data = false

		gen_spawn_is_patrol_chance = 0
		gen_spawn_turret_chance = 0
		gen_spawn_forpost_turret_fract = 1
		gen_setup_mobs_override = {ships_distr: [0], forposts: [0]}

		start_resources_amount = 10
		start_cargo_space = 200
	}
}

// objects
astar_graph = noone
astar_graph_inner = noone
