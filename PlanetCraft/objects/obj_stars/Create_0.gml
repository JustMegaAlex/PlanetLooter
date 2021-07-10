//// background
var surf_size = 2
var surf_w = scr_camw(0)*surf_size
var surf_h = scr_camh(0)*surf_size
var stars_num = 80
surf_stars = surface_create(surf_w, surf_h)
surface_set_target(surf_stars)
// draw stars
repeat(stars_num)
    draw_sprite(spr_stars,irandom(sprite_get_number(spr_stars)),
				random(surf_w),
				random(surf_h))
surface_reset_target()

// for surface drawing
x_ship_st = 0	// ship's starting location
y_ship_st = 0
if instance_exists(obj_looter) {
	x_ship_st = obj_looter.x
	y_ship_st = obj_looter.y
}
x_draw_stars_start = x_ship_st - surf_w * 0.5
y_draw_stars_start = y_ship_st - surf_h * 0.5

x_draw_stars = x_draw_stars_start
y_draw_stars = y_draw_stars_start
stars_parallax = 0.9
