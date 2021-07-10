
scr_move(sp, image_angle)
var inst = instance_place(x, y, obj_solid)
if inst and inst.side != side {
	inst.set_hit(dmg)
	instance_destroy()
}
