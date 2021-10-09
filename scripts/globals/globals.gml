
// room_resta
function reset_globals() {
	global.arr_patrol_routes = []
	global.astar_graph.clear()
}

// debug
global.DEBUG = true
global.ai_attack_off = false
global.player_immortal = true
global.no_damage = false
global.enable_instant_planet_move = true
global.enable_change_fps = true
global.show_planets_data = false
global.show_ai_patrol_routes = false
global.gen_create_enemies = true
global.show_path_finding_graph = false

// settings
global.ai_max_partol_route_length = 4

// objects
global.astar_graph = noone
