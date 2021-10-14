
// room_resta
function reset_globals() {
	global.arr_patrol_routes = []
	global.astar_graph.clear()
}

#macro Default:TEST_PATH_FIND false
#macro TestPathFinding:TEST_PATH_FIND true

// debug
global.DEBUG = true
global.ai_attack_off = true
global.player_immortal = true
global.no_damage = false
global.enable_instant_planet_move = true
global.enable_change_fps = true
global.show_planets_data = false
global.show_ai_patrol_routes = false
global.show_alert_tower_stuff = true
global.show_path_finding_graph = true

// settings
global.ai_max_partol_route_length = 4
global.path_finding_graph_collison_line_width = 30
global.gen_create_enemies = true
global.gen_planet_min_size = 10
global.gen_planet_max_size = 15
global.gen_max_planet_dist = 1000
global.gen_min_planet_number = 6
global.gen_max_planet_number = 8
global.gen_spawn_is_patrol_chance = 0.45
global.get_spawn_turret_chance = 0.2

// objects
global.astar_graph = noone
