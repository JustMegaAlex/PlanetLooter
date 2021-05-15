///@arg hsp
///@arg vsp
///@arg obj
function scr_move_coord_contact_obj(argument0, argument1, argument2) {

	x += argument0
	y += argument1

	//collision
	var contact = instance_place(x, y, argument2)

	if contact {
	
		// move out of an object
		while place_meeting(x, y, contact) {
		
	        x -= lengthdir_x(1, dir)
		
	        y -= lengthdir_y(1, dir)
		}
	}


}
