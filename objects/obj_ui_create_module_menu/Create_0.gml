
event_inherited()

function ModuleCreator(module_type, ui_parent) constructor {
	self.module_type = module_type
	self.ui_parent = ui_parent
	self.action = function() {
		var module = global.module_types[$ self.module_type]
		var inst = obj_looter
		var mess = inst.Resources.exchange("empty", 1, module.cost)
		if mess == "ok"
			return instance_create_layer(inst.x, inst.y, "Instances", module.object)
		self.ui_parent.ui_message(mess)
	}
}

sprite_index = -1

self.add_item(-1, "productor", new ModuleCreator("productor", id))
self.add_item(-1, "repair", new ModuleCreator("repair", id))
