
event_inherited()

function upgrade_weapon() {
	var res = obj_looter.upgrade_weapon()
	if res != "ok"
		ui_parent.ui_message(res, true)
}

function upgrade_repair() {
	var res = obj_looter.upgrade_repair()
	if res != "ok"
		ui_parent.ui_message(res, true)
}

function upgrade_speed() {
	var res = obj_looter.upgrade_speed()
	if res != "ok"
		ui_parent.ui_message(res, true)
}

function Upgrader(sys, ui_parent) constructor {
	self.sys = sys
	self.ui_parent = ui_parent
	upgrade = function() {
		var res = obj_looter.upgrade_system(self.sys)
		if res != "ok"
			self.ui_parent.ui_message(res, true)
	}
}



self.add_item(-1, "upgrade\nweapon", new Upgrader("weapon", id))
self.add_item(-1, "upgrade\nsp", new Upgrader("sp", id))
self.add_item(-1, "upgrade\ncargo", new Upgrader("cargo", id))
self.add_item(-1, "upgrade\ntank", new Upgrader("tank", id))
