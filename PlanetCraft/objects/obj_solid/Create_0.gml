
function set_hit(dmg) {
	hp -= dmg
	if hp <=0 {
		instance_destroy()
	}
}

side = Sides.neutral
hp = 1
