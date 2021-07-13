
event_inherited()

function produce_part() {
	var res = obj_looter.produce_part()
	if res != "ok"
		ui_parent.ui_message(res, true)
}

self.add_item(-1, "produce\n part", self.produce_part)
