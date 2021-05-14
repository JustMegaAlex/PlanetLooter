
scr_player_input()

up_free = place_empty(x, y - 1, obj_block)
down_free = place_empty(x, y + 1, obj_block)
left_free = place_empty(x - 1, y, obj_block)
right_free = place_empty(x + 1, y, obj_block)

move_h = key_right*right_free - key_left*left_free
move_v = (key_down*down_free - key_up*up_free) * !move_h
moving = abs(move_h) or abs(move_v)

// moving
if not dashing {
	if key_jump {
		// shooting plastic
		shoot_h = key_right_pressed*right_free - key_left_pressed*left_free
		shoot_v = (key_down_pressed*down_free - key_up_pressed*up_free) * !shoot_h
		if abs(shoot_h + shoot_v) {
			var _dir = point_direction(0, 0, shoot_h, shoot_v)
			var xx = x + lengthdir_x(cell_size, _dir)
			var yy = y + lengthdir_y(cell_size, _dir)
			var plastic = instance_create_layer(xx, yy, layer, obj_plastic)
			plastic.dir = _dir
		}
	}
	else if moving {
		dir = point_direction(0, 0, move_h, move_v)
		dashing = true
	}
} else {
	if ((vsp > 0) and !down_free) or ((vsp < 0) and !up_free) 
		vsp = 0

	if ((hsp > 0) and !right_free) or ((hsp < 0) and !left_free)
		hsp = 0

	if scr_move_contact_obj(sp, dir, obj_block)
		dashing = false
}


scr_camera_set_center(0, x, y)