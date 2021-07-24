
event_inherited()

function cost_info_text(type) {
	
}

var cost_info_text = 
self.add_item(-1, resource_cost_text(Resource.metall), new Producer(Resource.metall, id))
self.add_item(-1, resource_cost_text(Resource.fuel), new Producer(Resource.fuel, id))
