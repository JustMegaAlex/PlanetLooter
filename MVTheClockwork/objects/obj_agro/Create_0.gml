
event_inherited()

enum Agro {
	wander,
	attack,
}

function check_player_in_sight() {
	return point_distance(x, y, obj_run_man_2.x, obj_run_man_2.y) < attack_trigger_dist
		   and abs(obj_run_man_2.y - y) < 32
		   and sign(obj_run_man_2.x - x) == dirsign
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
throwing = 0
attack_trigger_dist = 180
acc = 1
throw_acc = 3