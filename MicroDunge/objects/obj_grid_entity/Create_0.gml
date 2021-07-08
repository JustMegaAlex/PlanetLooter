
event_inherited()

function step_event() {
	// define in child objects
	// performed on entity's turn
}

function init_move() {
	// define in child objects
	// performed on entity's turn start
}

function pass_turn() {
	my_turn = false
	move_finished = true
	quit_active_qeue()
}

function start_turn_move() {
	if inactive {
		global.turn_controller.next_move()
		move_finished = true
		return 0
	}
	global.turn_controller.active_qeue_push(id)
	self.init_move()
	my_turn = true
}

function move_to(ii, jj) {
	grid_move_to(ii, jj, self)
	i = ii
	j = jj
	x = gridx(i)
	y = gridy(j)
}

function dist_to(inst) {
	return grid_dist(i, j, inst.i, inst.j)
}

function try_move() {
	if abs(move_h) or abs(move_v) {
		var ii = i + move_h
		var jj = j + move_v
		if grid_at(ii, jj) == noone {
			move_to(ii, jj)
			return true
		}
	}
	return false
}

function attack(inst) {
	inst.set_attacked()
	if inst.destroyable {
		inst.hp--
		if inst.hp == 0
			instance_destroy(inst)
	}
}

function set_attacked() {
	instance_create_layer(gridx(i), gridy(j), layer, obj_hit_animation)
}

snap_to_grid(self)
i = gridi(x)
j = gridj(y)
grid_place_instance(self, i, j)
my_turn = false
move_finished = false

// entity properties
inactive = false
destroyable = true

// stats
hp = 0
dmg = 0
