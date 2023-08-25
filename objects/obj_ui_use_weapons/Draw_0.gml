
var num = array_length(obj_looter.use_weapon_arr)

draw_element(img_left, 0)
for (var i = 1; i < num; ++i) {
	var weap_ind = i - 1
	var weap_spr = obj_looter.use_weapon_arr[weap_ind].sprite
	var xx = step * (i - 0.5)
	var xoffs = sprite_get_xoffset(weap_spr) - sprite_get_width(weap_spr) * 0.5
	draw_element(0, xx + xoffs, weap_spr)
	if weap_ind == obj_looter.use_weapon_index
		draw_element(img_cell, xx)
    draw_element(img_divider, step * i)
}
if num {
	var weap_ind = i - 1
	var weap_spr = obj_looter.use_weapon_arr[weap_ind].sprite
	var xx = step * (i - 0.5)
	var xoffs = sprite_get_xoffset(weap_spr) - sprite_get_width(weap_spr) * 0.5
	draw_element(0, xx + xoffs, weap_spr)
	if weap_ind == obj_looter.use_weapon_index
		draw_element(img_cell, xx)
}
draw_element(img_right, max(step * num, 6))
