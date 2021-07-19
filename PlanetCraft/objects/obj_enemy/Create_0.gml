
event_inherited()

enum Enemy {
	idle,
	wander,
	enclose,
	distantiate,
	search,
}

function set_hit(weapon) {
	hp -= weapon.dmg
	if hp <= 0 {
		instance_destroy()
	}
	state = "search"
	searching = search_time
	dir = point_direction(x, y, obj_looter.x, obj_looter.y)
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
loose_dist = 500
close_dist = 200
detection_dist_search = 400
target = noone
search_time = 300
searching = 0

shoot_dir = 0
reloading = 0
weapon.reload_time = 40
bullet_sprite = spr_bullet_yellow

hp = 7

side = Sides.theirs
