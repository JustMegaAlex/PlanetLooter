
if resource_type != Resource.empty {
	var collectable = instance_create_layer(x, y, layer, obj_collectable)
	collectable.set_resource_type(resource_type)
}