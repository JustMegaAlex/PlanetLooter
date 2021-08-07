

enum Resource {
	empty,
	ore,
	organic,
	metall,
	fuel,
	part,
	junk,
	types_number
}

global.resource_names = array_create(Resource.types_number, "")
global.resource_names[Resource.ore] = "ore"
global.resource_names[Resource.organic] = "organic"
global.resource_names[Resource.metall] = "metall"
global.resource_names[Resource.fuel] = "fuel"
global.resource_names[Resource.part] = "part"
global.resource_names[Resource.junk] = "junk"


global.ResourceCost = {
	metall: [{type: "ore", ammount: 5}],
	fuel: [{type: "organic", ammount: 3}],
	part: [{type: "metall", ammount: 4}, 
		   {type: "junk", ammount: 1}],
}

global.resource_types = {}

function ResourceType(name, is_projectile, img_index, cost) constructor {
	self.name = name
	self.is_projectile = is_projectile
	self.cost = cost
	self.img_index = img_index
	if variable_struct_get(global.resource_types, name)
		throw "\n:ResourceType constructor: resource type with name '" + name + "' already exists"
	variable_struct_set(global.resource_types, name, self)
}

var zerocost = {}
rtype_empty = new ResourceType("empty", false, 0, zerocost)
rtype_ore = new ResourceType("ore", false, 1, zerocost)
rtype_organic = new ResourceType("organic", false, 2, zerocost)
rtype_metall = new ResourceType("metall", true, 3, global.ResourceCost.metall)
rtype_fuel = new ResourceType("fuel", false, 4, global.ResourceCost.fuel)
rtype_part = new ResourceType("part", false, 5, global.ResourceCost.part)
rtype_junk = new ResourceType("junk", false, 6, zerocost)


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
