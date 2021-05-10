
event_inherited()

function set_hit() {
	set_hit_base()
	core_object.take_damage(core_object.penetration_damage)
	hp -= core_object.segment_damage
	if !hp
		instance_destroy()
}

function set_stop() { core_object.state = States.stop }
function set_sp(val) { core_object.sp = val }
function set_dir(val) { core_object.dir = val }

hp = 4

core_object = noone
