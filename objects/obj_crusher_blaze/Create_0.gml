
image_speed = 0

var yoffset = 30
pos = new Vec2d(x, y, false)
relpos_initial = new Vec2d(yoffset, 90, true)
relpos = relpos_initial.copy()
relsp = noone

phase0_sp = new Vec2d(0.5, 120, true)
phase0_time = 10

hit_max_dist = 180
phase1_sp_mag = 24
phase2_sp_mag = 6

phase = -1
timer = -1

// image_yscale
assign_creation_arguments()

couple_instance = instance_create_layer(x, y, layer, obj_crusher_blaze_mirrored)
couple_instance.image_yscale = -1

self.weapon = {damage: 8}
