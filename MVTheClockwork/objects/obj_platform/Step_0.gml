
vsp = vsp_base * global.timesp
hsp = hsp_base * global.timesp
x += hsp
y += vsp

// change dir
if place_meeting(x, y, obj_trajectory_end) {
	hsp_base = -hsp_base
	vsp_base = -vsp_base
}
