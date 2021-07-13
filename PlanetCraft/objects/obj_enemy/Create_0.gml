
event_inherited()

enum Enemy {
	idle,
	wander,
	enclose,
	distantiate,
}

state = "idle"

is_moving_object = true
sp = 2.5
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.25
decel = 0.2
dir = 0

detection_dist = 300
loose_dist = 500
close_dist = 150
target = noone

shoot_dir = 0
reload_time = 30
reloading = 0
knock_back_force = 5

hp = 7
dmg = 1

side = Sides.theirs
