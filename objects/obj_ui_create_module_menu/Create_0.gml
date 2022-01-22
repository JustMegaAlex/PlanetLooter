
event_inherited()

function check_destroy_on_parent_far_away() {
	if point_distance(x, y, obj_looter.x, obj_looter.y) > disconnect_dist
		instance_destroy()
}

function ModuleCreator(module_type, ui_parent) constructor {
	self.module_type = module_type
	self.ui_parent = ui_parent
	self.action = function() {
		var module = global.module_types[$ self.module_type]
		var inst = obj_looter
		var mess = inst.Resources.exchange("empty", 1, module.cost)
		if mess == "ok"
			return instance_create_layer(inst.x, inst.y, "Instances", module.object)
		self.ui_parent.ui_message(mess, true)
		return noone
	}
}

self.add_item(-1, -1, "productor", new ModuleCreator("productor", id))
self.add_item(-1, -1, "repair", new ModuleCreator("repair", id))
