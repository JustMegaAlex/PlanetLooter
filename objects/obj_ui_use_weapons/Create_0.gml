
function draw_element(img, xx, spr=undefined) {
	if spr == undefined
		spr = sprite_index
	draw_sprite_ext(spr, img, x + xx*scale, y, scale, scale, 0, c_white, 1)
}

img_left = 0
img_right = 1
img_divider = 2
img_cell = 3
step = sprite_width
num = 0
scale = 2
y_from_screen_bottom = 40
x_from_screen_left = 100
