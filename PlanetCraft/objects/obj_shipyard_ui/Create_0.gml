
event_inherited()

function Upgrader(sys, ui_parent) constructor {
	self.sys = sys
	self.ui_parent = ui_parent
	action = function() {
		var res = obj_looter.upgrade_system(self.sys)
		if res != "ok"
			self.ui_parent.ui_message(res, true)
	}
}

Repairer = {
	ui_parent: id,
	action: function() {
		if obj_looter.hp >= obj_looter.hull {
			self.ui_parent.ui_message("hp full", true)
			return 0
		}
		if obj_looter.spend_resource(Resource.metall, 2) {
			obj_looter.hp++
			return 0	
		}
		self.ui_parent.ui_message("need more\n parts")
	}
}



self.add_item(-1, "upgrade\nweapon", new Upgrader("weapon", id))
self.add_item(-1, "upgrade\nsp", new Upgrader("sp", id))
self.add_item(-1, "upgrade\ncargo", new Upgrader("cargo", id))
self.add_item(-1, "upgrade\ntank", new Upgrader("tank", id))
self.add_item(-1, "upgrade\nhull", new Upgrader("hull", id))
self.add_item(-1, "repair", Repairer)
