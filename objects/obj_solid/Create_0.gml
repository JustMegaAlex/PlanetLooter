
function set_hit(attacker, weapon) {
	hp -= weapon.damage
	if hp <= 0 {
		instance_destroy()
	}
}

is_moving_object = false
side = Sides.neutral
hp = 1
