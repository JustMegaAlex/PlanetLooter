
function Particle(inst) constructor {
	follow = inst
	dir = random(360)
	y_phase = random(360)
	sp = irandom_range(6, 12) * choose(-1, 1)
	rx = 12 + irandom(4)
	ry = 12 + irandom(4)

	relx = lengthdir_x(rx, dir)
	rely = lengthdir_x(ry, dir + y_phase)

	update_pos = function() {
		dir += sp
		relx = lengthdir_x(rx, dir)
		rely = lengthdir_x(ry, dir + y_phase)
	}

	getx = function() { return follow.x + relx }
	gety = function() { return follow.y + rely }
}

function add_particle(inst) {
	var part = new Particle(inst)
	ds_list_add(particles, part)
}

function remove_particle(inst) {
	var ind = irandom(ds_list_size(particles) - 1)
	delete particles[| ind]
	ds_list_delete(particles, ind)
}

particles = ds_list_create()
color = $CCC2A3

// create initial particles
if instance_exists(obj_man) {
	repeat obj_man.stamina {
		add_particle(obj_man)
	}
}
