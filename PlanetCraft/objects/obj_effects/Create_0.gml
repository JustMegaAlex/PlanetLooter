

//// particle systems
part_sys_effects = part_system_create_layer("effects", false)
part_sys_effects_deep = part_system_create_layer("effects_deep", false)

//// projectiles
part_projectile_explosion = part_type_create()
part_projectile_explosion_small = part_type_create()
var life_time = sprite_get_number(spr_projectile_explosion) * 2
var life_time = sprite_get_number(spr_projectile_explosion) * 2
part_type_life(part_projectile_explosion, life_time, life_time)
part_type_life(part_projectile_explosion_small, life_time, life_time)
part_type_sprite(part_projectile_explosion, spr_projectile_explosion,  true, true, false)
part_type_sprite(part_projectile_explosion_small, spr_projectile_explosion,  true, true, false)
part_type_size(part_projectile_explosion_small, 0.5, 0.5, 0, 0)
function explosion(xx, yy) {
	part_particles_create(part_sys_effects,
						xx, yy,
						part_projectile_explosion, 1)
}

function explosion_small(xx, yy) {
	part_particles_create(part_sys_effects,
						xx, yy,
						part_projectile_explosion_small, 1)
}

function create_ship_explosion(inst) {
	with instance_create_layer(inst.x, inst.y, "Instances", obj_ship_explosion) {
		dir = inst.dir
		hsp = inst.hsp
		vsp = inst.vsp
		sprite_index = inst.sprite_index
	}
}


function create_debris(xx, yy, num) {
	repeat num
		instance_create_layer(xx, yy, "Instances", obj_ship_debris)
}

part_hit_sparks = part_type_create()
life_time = 15
part_type_sprite(part_hit_sparks,
					spr_hit_spark,
					true, true, false)
part_type_life(part_hit_sparks, life_time, life_time)
part_type_speed(part_hit_sparks, 4, 6, -0.2, 0)
part_type_scale(part_hit_sparks, 5, 1)
part_type_alpha2(part_hit_sparks, 1, 0.3)

function spark(xx, yy, dir, num) {
	part_type_direction(part_hit_sparks, dir-30, dir+30, 0, 0)
	part_type_orientation(part_hit_sparks, 0, 0, 0, 0, true)
	part_particles_create(part_sys_effects, xx, yy, part_hit_sparks, num)
}

//// engine thrust
// particles
part_jet_long = part_type_create()
part_jet = part_type_create()
var life_seconds = 0.16
var life_seconds_long = 0.25
var life_frames = life_seconds * room_speed
var life_frames_long = life_seconds_long * room_speed
var size_incr = -1 / life_frames
var size_incr_long = -1 / life_frames_long
part_jet_step_size = sprite_get_width(spr_particle_jet) * 0.15

part_type_life(part_jet, life_frames, life_frames)
part_type_sprite(part_jet, spr_particle_jet, true, true, false)
part_type_size(part_jet, 1, 1, size_incr, 0)

part_type_life(part_jet_long, life_frames_long, life_frames_long)
part_type_sprite(part_jet_long, spr_particle_jet, true, true, false)
part_type_size(part_jet_long, 1, 1, size_incr_long, 0)

function jet_long(xx, yy) {
	part_particles_create(part_sys_effects_deep, xx, yy, part_jet_long, 1)
}

function jet(xx, yy) {
	part_particles_create(part_sys_effects_deep, xx, yy, part_jet, 1)
}