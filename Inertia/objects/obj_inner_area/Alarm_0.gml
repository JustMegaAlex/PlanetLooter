
if free(x-1, y)
	bound(x, y, true, true)
if free(x, y-1)
	bound(x, y, false, false)
if free(x+1, y)
	bound(x + sprite_width, y, true, false)
if free(x, y+1)
	bound(x, y + sprite_width, false, true)
