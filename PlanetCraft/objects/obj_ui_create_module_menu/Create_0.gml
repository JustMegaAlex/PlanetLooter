
event_inherited()

function ModuleCreator(object) constructor {
	self.object = object
	self.action = function() {
		var inst = obj_looter
		instance_create_layer(inst.x, inst.y, "Instances", self.object)	
	}
}

sprite_index = -1

self.add_item(-1, "productor", new ModuleCreator(obj_production_module))
self.add_item(-1, "productor", new ModuleCreator(obj_production_module))
self.add_item(-1, "productor", new ModuleCreator(obj_production_module))
self.add_item(-1, "productor", new ModuleCreator(obj_production_module))
