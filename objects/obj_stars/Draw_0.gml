
x_draw_stars = x_draw_stars_start + (scr_camx_cent(0) - x_ship_st) * stars_parallax
y_draw_stars = y_draw_stars_start + (scr_camy_cent(0) - y_ship_st) * stars_parallax


//draw
if surface_exists(surf_stars)
	draw_surface(surf_stars, x_draw_stars, y_draw_stars)