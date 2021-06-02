
event_inherited()

enum Agro {
	wander,
	attack,
	being_hit,
}

function check_player_in_sight() {
	return point_distance(x, y, obj_run_man_2.x, obj_run_man_2.y) < attack_trigger_dist
		   and abs(obj_run_man_2.y - y) < 32
		   and sign(obj_run_man_2.x - x) == dirsign
}

function perform_attack_effect(obj) {
	if not throwing
		return false
	if obj.being_hit
		return false
	obj.set_hit()
	obj.hsp += hsp
	obj.vsp += attack_vertical_acc
	// limit sp
	obj.hsp = min(abs(obj.hsp), attack_throw_sp) * sign(obj.hsp)
	obj.vsp = max(obj.vsp, obj.jump_sp)
	with obj { scr_move_coord(hsp, vsp) }
	self.state = Agro.wander
	return true
}

function set_hit() {
	being_hit = after_hit_delay
	if not --hp {
		instance_destroy()
	}
}

//// collisions
right_free = true
left_free = true
down_free = true
up_free = true

state = Agro.wander
hsp_max = 3
hsp = 0
vsp = 0
dirsign = 1
hsp_to = hsp_max * dirsign
attack_pause_time = 50
prepairing_attack = 0
attack_throw_sp = 15
attack_throw_dist = 200
attack_vertical_acc = -5
throwing = 0
attack_trigger_dist = 180
acc = 1
throw_acc = 3

hp = 6
being_hit = 0
after_hit_delay = 30
