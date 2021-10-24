
if not instance_exists(spawner) {
	instance_destroy()
	exit
}

if not --spread_reloading {
	spread_reloading = spread_reload_time
	var _dir = spawner.dir + random(spread_angle) * choose(-1, 1)
	shoot(_dir, id, spread_bullet)
	if not --spread_num
		instance_destroy()
}

x = spawner.x
y = spawner.y
