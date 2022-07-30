
configuration = {
    show_path_finding_graph: {
        action: function() {
            global.debug_test_path_finding = !global.debug_test_path_finding
			global.show_path_finding_graph = !global.show_path_finding_graph
        }
    },
	show_enemy_routes: {
		action: function() {
			global.ai_show_move_routes = !global.ai_show_move_routes
		}
	},
	toggle_enemy_collisions: {
		action: function() {
			global.enemy_collisions_on = !global.enemy_collisions_on
		}
	}
}

turned_on = false
use_fnt = fnt_gui

joint_width = -1
joint_border_gap = 8

// joints placement
console_y = 10
console_ystep = sprite_get_height(spr_debug_console_joint)

function get_joint_width(text) {
	return string_width(text) + joint_border_gap * 2
}

function turn_on() {
    turned_on = true
    var joints = new IterStruct(configuration)
    var i = 0
	draw_set_font(use_fnt)

    while joints.next() {
        var name = joints.key()
        var action = joints.value().action
        var jnt = instance_create_layer(0, console_y + console_ystep * i,
                                        layer, obj_debug_console_joint)
        jnt.action_function = action
        jnt.name = name
		joint_width = max(joint_width, get_joint_width(name))
		i++
    }
	
	with(obj_debug_console_joint) {
		setup()
	}
}

function turn_off() {
    turned_on = false
    instance_destroy(obj_debug_console_joint)
}
