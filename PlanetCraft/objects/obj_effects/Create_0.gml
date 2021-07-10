

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
					
