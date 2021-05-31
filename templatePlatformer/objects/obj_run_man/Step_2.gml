
// solve collisions
//collider_hsp = 0
var contact = instance_place(x, y, obj_block)
while contact {
	self.resolve_collision(contact)
	// check collision with another object
	var contact = instance_place(x, y, obj_block)
}

up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block)
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

scr_camera_set_pos(0, x, y)
