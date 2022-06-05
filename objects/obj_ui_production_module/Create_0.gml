
event_inherited()

function cost_info_text(type) {
	
}

var s = spr_collectible
self.add_item(s, 1, resource_cost_text("metall"), new Producer("metall", id))
self.add_item(s, 2, resource_cost_text("fuel"), new Producer("fuel", id))
self.add_item(s, 5, resource_cost_text("part"), new Producer("part", id))
self.add_item(-1, -1, resource_cost_text("repair_kit"), new Producer("repair_kit", id))
self.add_item(spr_bullet_homing, 1, resource_cost_text("bullet_homing"), new Producer("bullet_homing", id))
self.add_item(-1, -1, resource_cost_text("drives"), new Producer("drives", id))
self.add_item(s, 7, resource_cost_text("b_orb"), new Producer("b_orb", id))
//self.add_item(s, resource_cost_text("chip"), new Producer("chipw", id))
