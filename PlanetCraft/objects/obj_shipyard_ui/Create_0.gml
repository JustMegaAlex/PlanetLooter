
event_inherited()

function upgrade_weapon() {
	var res = obj_looter.upgrade_weapon()
	if res != "ok"
		ui_parent.set_display_text(res)
}

self.add_item(-1, "upgrade\nweapon", self.upgrade_weapon)
