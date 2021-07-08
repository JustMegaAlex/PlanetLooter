
global.turn_controller = {
	active_entities: [],
	active_qeue: [],
	current_entity: -1,
	all_moves_finished: true,
	turns_total: -1,

	init_entities_list: function() {
		for (var k = 0; k < instance_number(obj_grid_entity); ++k) {
		    var inst = instance_find(obj_grid_entity, k)
			array_push(active_entities, inst)
		}
	},

	next_move: function() {
		// find not moved entities
		if !global.game_over {
			while true {
				current_entity++
				if current_entity >= array_length(active_entities) {
					if all_moves_finished {
						next_turn()
						return 0
					}
					current_entity = 0
					all_moves_finished = true
				}
				var inst = active_entities[current_entity]
				if !inst.inactive and !inst.move_finished {
					// set false as entity may skip its current move
					all_moves_finished = false
					inst.start_turn_move()
					return 0
				}
			}
		}
	},

	next_turn: function() {
		turns_total++
		all_moves_finished = true
		current_entity = -1
		with obj_grid_entity {
			move_finished = false
		}
		next_move()
	},

	remove_from_active_qeue: function(inst) {
		array_remove(active_qeue, inst)
	},

	active_qeue_push: function(inst) {
		if array_find(active_qeue, inst) != -1
			throw (" :obj_turn_controller.active_qeue_push(): instance is already in qeue")
		array_push(active_qeue, inst)
	},

	active_qeue_empty: function() {
		return array_length(active_qeue) == 0
	},
	
	remove_from_active_entities: function(inst) {
		array_remove(active_entities, inst)
	},
	
	clear_data: function() {
		active_entities = []
		active_qeue = []
	}
}
