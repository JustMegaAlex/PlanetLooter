
var num = instance_number(obj_planet)
if keyboard_check_pressed(ord("O")) {
	current_planet = cycle_increase(current_planet, 0, num)
	move_to_planet(current_planet)
}
if keyboard_check_pressed(ord("P")) {
	current_planet = cycle_increase(current_planet, 0, num)
	move_to_planet(current_planet)
}