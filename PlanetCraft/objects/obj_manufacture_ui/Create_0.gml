
event_inherited()

function produce_part() {
	var res = obj_looter.produce_part()
	if res != "ok"
		ui_parent.set_display_text(res)
}

self.add_item(-1, "produce\n part", self.produce_part)
