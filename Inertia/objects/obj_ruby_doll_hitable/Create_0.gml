
event_inherited()

function scan_dirs(scandist) {
	var dirs = []
	var dists = []
	var maxdist = 0
	for (var i = 0; i < 4; ++i) {
		var dir = i * 90
		var dist = scan(dir, scandist)
		maxdist = max(dist, maxdist)
		dirs[i] = dir
		dists[i] = dist
	}
	finaldirs = []
	j = 0
	for (var i = 0; i < 4; ++i) {
		if dists[i] == maxdist
			finaldirs[j++] = dirs[i]
	}
	return [finaldirs, maxdist]
}

function scan(dir, scandist) {
	scanx = x + lengthdir_x(scandist, dir)
	scany = y + lengthdir_y(scandist, dir)
	xy = line_intersection(x, y, scanx, scany, obj_bound)
	dist = point_distance(x, y, xy[0], xy[1])
	return dist
}

hull_segments_objects = [obj_ruby_back, obj_ruby_left, obj_ruby_right]
projectile = noone
side = Sides.machina

spmax = 1
sp = 0
acc = 0.1
scandist = 200
wanderdist_delta = sprite_height * 0.5
xto = x
yto = y
dir = 0
shootdist = 250
