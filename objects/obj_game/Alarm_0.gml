
view_enabled = true
view_visible[0] = true
var w = display_get_width()
var h = display_get_height()
var scale = global.view_to_window_ratio
camera_set_view_size(view_camera[0], w * scale, h * scale)
