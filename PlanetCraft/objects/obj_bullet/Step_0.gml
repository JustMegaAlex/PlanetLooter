
life_distance -= weapon.sp
if not life_distance {
	instance_destroy()
	exit
}

xprev = x
yprev = y
move()
bring_damage()

