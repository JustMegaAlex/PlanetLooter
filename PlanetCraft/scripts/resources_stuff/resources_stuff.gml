

enum Resource {
	empty,
	ore,
	organic,
	metall,
	fuel,
	part,
	types_number
}

global.resource_names = array_create(Resource.types_number, "")
global.resource_names[Resource.ore] = "ore"
global.resource_names[Resource.organic] = "organic"
global.resource_names[Resource.metall] = "metall"
global.resource_names[Resource.fuel] = "fuel"
global.resource_names[Resource.part] = "part"


global.ResourceCost = {
	metall: {type: Resource.ore, ammount: 3},
	fuel: {type: Resource.organic, ammount: 2},
	part: {type: Resource.metall, ammount: 2},
}

function spawn_resource_item(type, xx, yy, sp, dir) { // sp1, sp2, sp_is_coords) {
	//if sp_is_coords {
	//	var sp = point_distance(0, 0, sp1, sp2)
	//	var dir = point_direction(0, 0, sp1, sp2)
	//} else {
	//	sp = sp1
	//	dir = sp2
	//}
	var collectable = instance_create_layer(xx, yy, "Instances", obj_collectable)
	collectable.set_resource_type(type)
	collectable.sp = sp
	collectable.dir = dir
}