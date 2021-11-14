

global.resource_types = {}

function ResourceType(name, img_index, cost, production_time=60) constructor {
	self.name = name
	self.is_bullet = false // is defined by weapon system
	self.bullet_name = ""
	self.cost = cost
	self.img_index = img_index
	self.production_time = production_time
	if variable_struct_get(global.resource_types, name)
		throw "\n:ResourceType constructor: resource type with name '" + name + "' already exists"
	variable_struct_set(global.resource_types, name, self)
}

function helper_cost_struct() {
	
}

var zerocost = {}
rtype_empty = new ResourceType("empty", 0, zerocost)
rtype_ore = new ResourceType("ore", 1, zerocost)
rtype_organic = new ResourceType("organic", 2, zerocost)
rtype_metall = new ResourceType("metall", 3, {ore: 3})
rtype_fuel = new ResourceType("fuel", 4, {organic: 3})
rtype_part = new ResourceType("part", 5, {metall: 4, junk: 1})
rtype_junk = new ResourceType("junk", 6, zerocost)
rtype_bullet_homing = new ResourceType("bullet_homing", 0, {metall:1, drives:1, part:1})
rtype_drives = new ResourceType("drives", 0, {junk: 1, metall: 3})
rtype_chip = new ResourceType("chip", 0, {part: 2, metall: 5, junk: 1})
rtype_repairkit = new ResourceType("repair_kit", 0, {metall: 1, drives: 1})
raction_repairment = new ResourceType("repairment", 0, {metall: 5})


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
