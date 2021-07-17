
spawn_timer = 0
count_to_death = 10
phase = 0
hsp = 0
vsp = 0
sp = 6
move_dir = random(360)
rot_sp = choose(1, -1) * random_range(5, 20)
dir = 0

obj_effects.explosion_big(
	x - lengthdir_x(5, move_dir),
	y - lengthdir_y(5, move_dir)
)
