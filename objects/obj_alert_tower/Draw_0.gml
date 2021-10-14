
draw_self()

if global.show_alert_tower_stuff {
	draw_text_above_me(string(ships_left) + "/" + string(ships_at_start))
	for (var i = 0; i < array_length(arr_ships); ++i) {
		var ship = arr_ships[i]
	    draw_line(x, y, ship.x, ship.y)
	}
}
