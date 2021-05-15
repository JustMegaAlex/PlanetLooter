
function scr_move_coord_contact_obj(hsp, vsp, obj) {
	x += hsp
	y += vsp
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
