
hsp = 0
vsp = 0

function left_bound() {
	return new Line(bbox_left, bbox_top, bbox_left, bbox_bottom)
}
function right_bound() {
	return new Line(bbox_right, bbox_top, bbox_right, bbox_bottom)
}
function top_bound() {
	return new Line(bbox_left, bbox_top, bbox_right, bbox_top)
}
function bottom_bound() {
	return new Line(bbox_left, bbox_bottom, bbox_right, bbox_bottom)
}
