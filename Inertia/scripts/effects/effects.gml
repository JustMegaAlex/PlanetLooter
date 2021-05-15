
particle_system = part_system_create()

eff_super_move_type = part_type_create()
var ltime = room_speed * 0.5
part_type_life(eff_super_move_type, ltime, ltime)
part_type_sprite(eff_super_move_type, spr_supermove_eff, false, false, false)
part_type_alpha2(eff_super_move_type, 1, 0)
eff_supermove_spawn_time = 5

function eff_supermove(x, y, angle) {
	part_type_orientation(global.eff_super_move_type, angle, angle, 0, 0, 0)
	part_particles_create(global.particle_system, x, y, global.eff_super_move_type, 1)
}
