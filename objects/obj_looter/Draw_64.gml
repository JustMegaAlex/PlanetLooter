
scr_debug_show_var("velocity_to.x", velocity_to.X)
scr_debug_show_var("velocity_to.y", velocity_to.Y)
scr_debug_show_var("hp", string(hp))
scr_debug_show_var("", "")
scr_debug_show_var("cargo", string(cargo_load) + "/" + string(cargo))
scr_debug_show_var("fuel", string(tank_load) + "/" + string(tank))
scr_debug_show_var("", "")
scr_debug_show_var("diff", _diff)

for (var i = 0; i < array_length(resources_display_names); ++i) {
    var nm = resources_display_names[i]
	scr_debug_show_var(nm, string(resources[$ nm]))
}
scr_debug_show_var("", "")

