///@arg speed
///@arg dir
function scr_move(sp, dir) {
	x += lengthdir_x(sp, dir)
	y += lengthdir_y(sp, dir)
}

function scr_move_coord(hsp, vsp) {
	x += hsp
	y += vsp
}
