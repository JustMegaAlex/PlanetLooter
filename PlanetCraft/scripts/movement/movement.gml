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

function scr_move_coord_contact_obj(hsp, vsp, obj) {
	scr_move_coord(hsp, vsp)
	//collision
	var contact = instance_place(x, y, obj)
	if contact  {
		// compute relative movement
		var relhsp = hsp - contact.hsp
		var relvsp = vsp - contact.vsp
		var reldir = point_direction(0, 0, relhsp, relvsp)
		// move out of an object
		while place_meeting(x, y, contact) {
	        x -= lengthdir_x(1, reldir)
	        y -= lengthdir_y(1, reldir)
		}
	}
}

function scr_move_contact_obj(sp, dir, obj) {
	scr_move(sp, dir)
	//collision
	var contact = instance_place(x, y, obj)
	if contact {
		// move out of an object
		while place_meeting(x, y, contact) {
	        x -= lengthdir_x(1, dir)
	        y -= lengthdir_y(1, dir)
		}
	}
}
