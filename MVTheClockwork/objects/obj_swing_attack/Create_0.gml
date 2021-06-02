
push_hsp = 10
image_speed = 1.5

image_xscale = obj_run_man_2.dirsign

var inst = instance_place(x, y, obj_agro)
if inst {
	inst.set_hit()
	inst.hsp = push_hsp * obj_run_man_2.dirsign
}
