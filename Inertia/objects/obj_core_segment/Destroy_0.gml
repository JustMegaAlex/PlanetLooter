
var stamina_ammount = stamina_cost + array_length(hull_segments)
instance_create_many(x, y, layer, obj_stamina, stamina_ammount)

while array_length(hull_segments) {
	var seg = hull_segments[0]
	instance_destroy(seg)
}
