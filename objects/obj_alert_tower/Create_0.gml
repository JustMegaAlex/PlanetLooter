
event_inherited()

function ships_set_death_signalize() {
	foreach(arr_ships,
		function(ship) {
			ship.alert_tower_inst = id
		}
	)
}

function ship_death_signal(ship) {
	array_remove(arr_ships, ship)
	ships_left = array_length(arr_ships)
	if (ships_left / ships_at_start) < alert_trigger_factor
		send_emergency_request()
}

function send_emergency_request() {
	foreach_instance(obj_alert_tower,
		function(inst) {
			return inst.handle_emergency_request(id)
		}
	)
}

function handle_emergency_request(other_tower) {
	var num_to_send = ceil(ships_left * send_units_on_emergency)
	if num_to_send == 0
		return false
	for (var i = 0; i < num_to_send; ++i) {
	    var ship = arr_ships[i]
		var switched = ship.state_switch_on_route(other_tower.x, other_tower.y)
		if !switched
			return false
	}
	return true
}

// args
alert_trigger_factor = 0.25 // ships_left / ships_at_start
send_units_on_emergency = 0.5
arr_ships = []

assign_creation_arguments()
ships_set_death_signalize()

hp = 20
side = Sides.theirs

// alert
ships_at_start = array_length(arr_ships)
ships_left = ships_at_start
