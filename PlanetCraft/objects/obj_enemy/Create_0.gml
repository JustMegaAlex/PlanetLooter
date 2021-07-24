
event_inherited()

enum Enemy {
	idle,
	wander,
	enclose,
	distantiate,
	search,
}

function set_hit(weapon) {
	hp -= weapon.dmg * obj_debug.capture_damage(id)
	state = "warmup"
	dir = point_direction(x, y, obj_looter.x, obj_looter.y)
	trigger_friendly_units()
	if hp <= 0 {
		instance_destroy()
	}
}

function trigger_friendly_units() {
	ds_list_empty(friendly_units_to_trigger)
	collision_circle_list(x, y, trigger_radius_on_detection, obj_enemy, false, true, friendly_units_to_trigger, false)
	alarm[1] = trigger_units_delay
}

function compute_strafe_vec() {
	for (var i = 0; i < instance_number(obj_enemy); ++i) {
		var inst = instance_find(obj_enemy, i)
	    var dist = max(inst_dist(inst), 1)
		if (dist > battle_friendly_dist) or (inst == id)
			continue
		var dir = inst_dir(inst)
		battle_strafe_vec.add_polar(-1 / dist, dir)
	}
	battle_strafe_vec.normalize()
}

state = "idle"

is_moving_object = true
sp.normal = 2.5
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.25
decel = 0.2
dir = 0

detection_dist = 300
trigger_radius_on_detection = 200
trigger_units_delay = 5
friendly_units_to_trigger = ds_list_create()
dir_wiggle = 0
dir_wiggle_magnitude = 40
dir_wiggle_change_time = 30
dir_wiggle_delay = 0
loose_dist = 500
close_dist = 200
detection_dist_search = 400
target = noone
search_time = 300
searching = 0
xst = x
yst = y
start_area_radius = 100

shoot_dir = 0
shoot_dir_wiggle = 8
reloading = 0
weapon.reload_time = 25
bullet_sp = 24
bullet_sprite = spr_bullet_yellow
warmedup = 0
warmup_sp = 0.01

// keeping distance with friends
battle_friendly_dist = 100
battle_strafe_vec = new Vec2d(0, 0)

// controlled building
controlled_building = noone

hp = 7

side = Sides.theirs
