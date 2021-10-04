
scr_debug_show_var("velocity_to.x", velocity_to.X)
scr_debug_show_var("velocity_to.y", velocity_to.Y)
scr_debug_show_var("hp", string(hp))
scr_debug_show_var("", "")
scr_debug_show_var("cargo", string(cargo_load) + "/" + string(cargo))
scr_debug_show_var("fuel", string(tank_load) + "/" + string(tank))
scr_debug_show_var("", "")

var names = variable_struct_get_names(resources)
for (var i = 0; i < array_length(names); ++i) {
    var nm = names[i]
	scr_debug_show_var(nm, string(resources[$ nm]))
}
scr_debug_show_var("", "")

