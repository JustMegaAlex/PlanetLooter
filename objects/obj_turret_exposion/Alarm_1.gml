
obj_effects.explosion_big(x + random(16) * choose(-1, 1),
						  y + random(16) * choose(-1, 1))

if --explosions
	alarm[1] = time_between_explosions
else {
	obj_effects.create_debris(x, y, choose(2, 3))
	instance_destroy()
}
