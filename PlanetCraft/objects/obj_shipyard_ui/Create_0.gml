
event_inherited()

function upgrade_weapon() {
	var res = obj_looter.upgrade_weapon()
	if res != "ok"
		ui_parent.set_display_text(res)
}

function upgrade_repair() {
	var res = obj_looter.upgrade_repair()
	if res != "ok"
		ui_parent.set_display_text(res)
}

function upgrade_speed() {
	var res = obj_looter.upgrade_speed()
	if res != "ok"
		ui_parent.set_display_text(res)
}



self.add_item(-1, "upgrade\nweapon", self.upgrade_weapon)
self.add_item(-1, "repair", self.upgrade_repair)
self.add_item(-1, "upgrade\nspeed", self.upgrade_speed)
