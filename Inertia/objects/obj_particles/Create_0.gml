
function Particle(inst) constructor {
	relx = irandom_range(-32, 32)
	rely = irandom_range(-32, 32)
	follow = inst
	sp = irandom_range(10, 30) * choose(-1, 1)
	r = point_distance(0, 0, relx, rely)
	dir = point_direction(0, 0, relx, rely)
	
	update_pos = function() {
		dir += sp
		relx = lengthdir_x(r, dir)
		rely = lengthdir_y(r, dir)
	}

	getx = function() { return follow.x + relx }
	gety = function() { return follow.y + rely }
}

function add_particle(inst) {
	var part = new Particle(inst)
	ds_list_add(particles, part)
}

particles = ds_list_create()
