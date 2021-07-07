
global.turn_controller = {
	active_entities: [],
	current_entity: -1,
	all_moves_finished: true,
	turns_total: 0,

	init_entities_list: function() {
		var num = instance_number(obj_active_entity)
		for (var k = 0; k < instance_number(obj_active_entity); ++k) {
		    var inst = instance_find(obj_active_entity, k)
			array_push(active_entities, inst)
		}
	},

	remove_entity: function(inst) {},

	next_move: function() {
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
			if not inst.move_finished {
				all_moves_finished = false
				inst.my_turn = true
				inst.init_move()
				return 0
			}
		}
	},
	
	next_turn: function() {
		turns_total++
		all_moves_finished = true
		current_entity = -1
		with obj_active_entity {
			move_finished = false
		}
		next_move()
	}
}
