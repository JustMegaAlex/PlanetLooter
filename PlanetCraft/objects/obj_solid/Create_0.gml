
function set_hit(weapon) {
	hp -= weapon.dmg
	if hp <=0 {
		instance_destroy()
	}
}

is_moving_object = false
side = Sides.neutral
hp = 1
