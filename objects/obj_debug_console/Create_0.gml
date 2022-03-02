
configuration = {
    toggle_path_finding: {
        action: function() {
            global.debug_test_path_finding = !global.debug_test_path_finding
        }
    }
}

turned_on = false

// joints placement
console_x = window_get_width() - sprite_get_width(spr_debug_console_joint)
console_ystep = sprite_get_height(spr_debug_console_joint)

function turn_on() {
    turned_on = true
    var joints = new IterStruct(configuration)
    var i = 0
    while joints.next() {
        var name = joints.key()
        var action = joints.value()
        var jnt = instance_create_layer(console_x, console_ystep * i,
                                        layer, obj_debug_console_joint)
        jnt.action = action
        jnt.name = name
    }
}

function turn_off() {
    turned_on = false
    instance_destroy(obj_debug_console_joint)
}
