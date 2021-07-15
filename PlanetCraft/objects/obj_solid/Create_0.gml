
function set_hit(weapon) {
	hp -= weapon.dmg
	if hp <=0 {
		instance_destroy()
	}
}

side = Sides.neutral
hp = 1
