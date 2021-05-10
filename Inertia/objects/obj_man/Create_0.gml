
event_inherited()

function get_input() {
	if input_right
		return vk_right
	if input_left
		return vk_left
	if input_up
		return vk_up
	if input_down
		return vk_down
}

function get_input_type2() {
	if input_right and input_key != vk_right
		return vk_right
	if input_left and input_key != vk_left
		return vk_left
	if input_up and input_key != vk_up
		return vk_up
	if input_down and input_key != vk_down
		return vk_down
	return input_key
}

function get_dir(key) {
	if key == vk_right
		return 0
	if key == vk_up
		return 90
	if key == vk_left
		return 180
	if key == vk_down
		return 270
}

function set_hit() {
	if not --durance
		instance_destroy()
}

function set_image_angle(angle) {
	
}

hull_segments_objects = []

hsp = 0
vsp = 0
spmax = 5
sp = 0
acc = 0.2
decel = 0.1
dir = 0
core_damage = 0
stamina = 10
durance = 10

reload_time = 10
reloading = 0

side = Sides.human
