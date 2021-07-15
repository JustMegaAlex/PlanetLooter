

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
