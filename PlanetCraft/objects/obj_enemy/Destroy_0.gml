
obj_effects.create_ship_explosion(id)
var chnc = random(1)
if chnc > 0.85
	spawn_resource_item(Resource.part, x, y, 1, random(360))
else if chnc > 0.5
	spawn_resource_item(Resource.fuel, x, y, 1, random(360))

if chance(0.5)
	spawn_resource_item(Resource.junk, x, y, 1, random(360))

ds_list_destroy(friendly_units_to_trigger)
