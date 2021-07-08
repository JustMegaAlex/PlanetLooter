
if global.game_over {
	draw_set_valign(fa_middle)
	draw_set_halign(fa_center)
	var xx = scr_camx(0) + scr_camw(0) * 0.5
	var yy = scr_camy(0) + scr_camh(0) * 0.5
	var text = "Game over\npress R"
	draw_text_transformed_color(xx, yy, text, 1, 1, 0, c_red, c_red, c_red, c_red, 1)
}
