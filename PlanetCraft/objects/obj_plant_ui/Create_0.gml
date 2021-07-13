
event_inherited()

function produce_metal() {
	var res = obj_looter.ore_to_metall()
	if res != "ok"
		ui_parent.ui_message(res, true)
}

function produce_fuel() {
	var res = obj_looter.organic_to_fuel()
	if res != "ok"
		ui_parent.ui_message(res, true)
}

self.add_item(-1, "produce\nmetal", self.produce_metal)
self.add_item(-1, "produce\nfuel", self.produce_fuel)
