

//// particle systems
part_sys_effects = part_system_create_layer("effects", false)

//// projectiles
part_projectile_explosion = part_type_create()
var life_time = sprite_get_number(spr_projectile_explosion) * 2
part_type_life(part_projectile_explosion,
					life_time,
					life_time)
part_type_sprite(part_projectile_explosion, 
					spr_projectile_explosion, 
					true, true, false)

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