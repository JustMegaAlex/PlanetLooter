
scr_move(sp, image_angle)
var inst = instance_place(x, y, obj_solid)
if inst and inst.side != side {
	inst.set_hit(dmg)
	part_particles_create(obj_effects.part_sys_effects,
							x, y,
							obj_effects.part_projectile_explosion, 1)
	instance_destroy()
}
