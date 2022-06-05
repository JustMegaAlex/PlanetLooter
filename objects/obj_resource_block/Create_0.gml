resource_data_map = {
	obj_rb_ore_big : new BlockResourceData(
							"ore", 15, 3),
	obj_rb_ore_medium : new BlockResourceData(
							"ore", 5, 3),
	obj_rb_ore_small : new BlockResourceData(
							"ore", 2, 3),
}

if variable_struct_exists(
		resource_data_map, object_get_name(object_index))
	resource_data = variable_struct_get(
		resource_data_map, object_get_name(object_index))

make_late_init()
