
event_inherited()

function set_sp_to(sp, dir) {
	hsp_to = lengthdir_x(sp, dir)
	vsp_to = lengthdir_y(sp, dir)
}

// systems
hp = 7
weapon = {
	dmg: 1,
	mining: 1,
	reload_time: 10,
	consumption: 0.1,
	knock_back_force: 4.5
}

sp = {normal: 5, cruise: 10, consumption: 0.005}
