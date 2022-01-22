
event_inherited()

draw_self()
if production_time_left {
	var s = spr_production_module_progress_indicator
	var left = 0
	var width = sprite_get_width(s)
	var bottom = sprite_get_height(s)
	var height = (bottom) * (1 - production_time_left / production_time_total)
	var top = bottom - height
	draw_sprite_part(s, 0, left, top, width, bottom, x - 4, y + 8 - height)
}