
event_inherited()

function attack(inst) {
	inst.set_attacked()
	if inst.destroyable {
		inst.hp--
		if inst.hp == 0
			instance_destroy(inst)
	}
}


hdir = 0
vdir = 0
visible = false
sp_base = 4
sp = 0
alarm[0] = 1