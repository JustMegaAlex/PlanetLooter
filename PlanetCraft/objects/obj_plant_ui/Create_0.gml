
event_inherited()


function Productor(resource, ui_parent) constructor {
	self.type = resource
	self.type_name = global.resource_names[resource]
	self.ui_parent = ui_parent
	action = function() {
		var cost = variable_struct_get(global.ResourceCost, self.type_name)
		if obj_looter.resources[cost.type] < cost.ammount {
			var msg = "need more\n" + global.resource_names[cost.type]
			self.ui_parent.ui_message(msg, true)
			return 0
		}
		// check cargo capacity
		var cargo_after = (obj_looter.cargo_load + 1 - cost.ammount)
		if cargo_after > obj_looter.cargo {
			self.ui_parent.ui_message("cargo full", true)
			return 0
		}
		obj_looter.resources[cost.type] -= cost.ammount
		obj_looter.resources[self.type]++	
		obj_looter.cargo_load = cargo_after
	}
}

self.add_item(-1, "produce\nmetal", new Productor(Resource.metall, id))
self.add_item(-1, "produce\nfuel", new Productor(Resource.fuel, id))
