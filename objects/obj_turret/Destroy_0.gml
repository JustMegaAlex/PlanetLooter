
with instance_create_layer(x, y, layer, obj_turret_exposion)
	self.image_angle = other.image_angle
	
	
var chnc = random(1)
if chnc > 0.6
	spawn_resource_item("part", x, y, 1, random(360))

if chance(0.5)
	spawn_resource_item("junk", x, y, 1, random(360))
