
scr_move(sp, image_angle)
var inst = instance_place(x, y, obj_block)
if inst {
	inst.set_hit()
	instance_destroy()
}
