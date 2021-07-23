
draw_sprite_ext(sprite_index, image_index, x, y, 1, 1, dir, c_white, 1)

draw_text(x, y - 40, warmedup)
var xx = x + lengthdir_x(100, battle_friendly_angle)
var yy = y + lengthdir_y(100, battle_friendly_angle)
draw_line(x, y, xx, yy)
//draw_text(x, y - 20, "sp to: " + string(hsp_to) + " " + string(vsp_to))
