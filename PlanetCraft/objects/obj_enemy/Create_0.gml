
event_inherited()

enum Enemy {
	idle,
	wander,
	enclose,
	distantiate,
}

state = "idle"

sp = 2.5
hsp = 0
vsp = 0
hsp_to = 0
vsp_to = 0
acc = 0.25
decel = 0.2

detection_dist = 300
loose_dist = 400
close_dist = 150
target = noone

shoot_dir = 0
reload_time = 30
reloading = 0

hp = 7
dmg = 1

side = Sides.theirs
