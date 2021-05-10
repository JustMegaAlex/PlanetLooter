
scr_move(sp, image_angle)
var poor_instance = instance_place(x, y, obj_collide)
if poor_instance and poor_instance.side != side {
	poor_instance.set_hit()
	instance_destroy()	
}