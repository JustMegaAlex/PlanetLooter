
event_inherited()

enum States {
	walk,
	fly,
	dash,
	timeshift,
	onwall,
}

state = States.walk

jumps_max = 1
jumps = jumps_max
jump_press_delay = 15
jump_pressed = 0
on_ground_delay = 10
platform_obj = noone
on_ground = 0 // used to fake ground for smoother jumping
on_wall = false
dirsign = 1
dashtime = 5
dashsp = 45
dashing = false
dashcooldown = 0
dashcooldowntime = 20
timeshiftammount = 180
timeshift_sp = -2
