
event_inherited()

enum States {
	stop,
	scan,
	wander,
}

function init() {
	alarm[0] = 1
}

function init_segments() {
	for(var i=0; i < array_length(hull_segments_objects); i++) {
		var seg = instance_create_layer(x, y, layer, hull_segments_objects[i])
		hull_segments[i] = seg
		seg.core_object = self
		seg.side = side
	}
}

function update_segments() {
	for(var i=0; i < array_length(hull_segments); i++) {
		var seg = hull_segments[i]
		seg.x = x
		seg.y = y
		seg.image_angle = image_angle
	}
}

function remove_segment(_id) {
	var old_segments = hull_segments
	hull_segments = []
	var j = 0
	for(var i=0; i < array_length(old_segments); i++) {
		var seg = old_segments[i]
		if seg != _id
			hull_segments[j++] = seg
	}
}

function check_collision(_x, _y, obj) {
	if place_meeting(_x, _y, obj)
		return true
	for(var i=0; i < array_length(hull_segments); i++) {
		var seg = hull_segments[i]
		with seg {
			if place_meeting(_x, _y, obj)
				return true
		}
	}
	return false
}

function set_hit() {
	set_hit_base()
	take_damage(core_damage)
}

function take_damage(dmg) {
	hp -= dmg
	if !hp
		instance_destroy()
}

function set_stop() { state = States.stop }
function set_sp(val) { sp = val }
function set_dir(val) { dir = val }

hull_segments_objects = []
hull_segments = []
hp = 10
segment_damage = 2
core_damage = 2
penetration_damage = 1
stamina_cost = 3
stamina_per_segment = 1
state = States.stop

init()


