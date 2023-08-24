
event_inherited()

draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)

if target_point
	draw_circle(target_point.X, target_point.Y, 4, false)

var p = global.AIVelocity.get_scan_center(position, velocity)
draw_circle(p.X, p.Y, global.AIVelocity.scan_radius, true)

ds_list_clear(global.AIVelocity.affectors)

var iter = new IterArray(global.AIVelocity.ray_scanners)
while iter.next() {
	var scanner = iter.get()
	var col = scanner.positive ? c_red : c_white
	geometry_draw_line(scanner.line, col)
}

var vec = global.AIVelocity.resulting_vector
vec.mult(30)
draw_line(x, y, x + vec.X, y + vec.Y)

vec = velocity.mult_(30)
draw_line(x, y, x + vec.X, y + vec.Y)

