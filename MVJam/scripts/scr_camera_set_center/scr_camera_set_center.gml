///@func scr_cameraSetCenter(camera,x,y)
///@desc set view center
///@arg camera
///@arg {real} x
///@arg {real} y
function scr_camera_set_center(argument0, argument1, argument2) {
	camera_set_view_pos(view_camera[argument0],
						argument1-camera_get_view_width(view_camera[argument0])*0.5,
						argument2-camera_get_view_height(view_camera[argument0])*0.5);


}
