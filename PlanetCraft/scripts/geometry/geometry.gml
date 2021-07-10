
function Point(_x, _y) constructor {
	x_ = _x
	y_ = _y

	static add = function(dx, dy) {
		return new Point(self.x_ + dx, self.y_ + dy)
	}
}


function Line(_xst, _yst, _xend, _yend) constructor  {
	xst = _xst
	yst = _yst
	xend = _xend
	yend = _yend
	
	static mult = function(m) {
		xend = xst + (xend - xst) * m
		yend = yst + (yend - yst) * m
	}
	
	static set = function(_xst, _yst, _xend, _yend) {
		xst = _xst
		yst = _yst
		xend = _xend
		yend = _yend
	}
	
	static setst = function(_xst, _yst) {
		xst = _xst
		yst = _yst
	}
	
	static setend = function(_xend, _yend) {
		xend = _xend
		yend = _yend
	}
	
	static draw = function() {
		draw_line(xst, yst, xend, yend)
	}
}

global.INF = 1000000

function line_intersection(l1, l2, segment){
	var x0, y0, x1, y1, x2, y2, x3, y3
	x0 = l1.xst
	y0 = l1.yst
	x1 = l1.xend
	y1 = l1.yend
	x2 = l2.xst
	y2 = l2.yst
	x3 = l2.xend
	y3 = l2.yend
    var ua, ub, ud, ux, uy, vx, vy, wx, wy
    ua = 0
    ux = x1 - x0
    uy = y1 - y0
    vx = x3 - x2
    vy = y3 - y2

	// ensure lines are not parallel
	if vy == 0
		if uy == 0
			return global.INF
	if ux / uy == vx / vy
		return global.INF

    wx = x0 - x2
    wy = y0 - y2
    ud = vy * ux - vx * uy
    if (ud != 0) 
    {
        ua = (vx * wy - vy * wx) / ud
        if (segment) 
        {
            ub = (ux * wy - uy * wx) / ud
            if (ua <= 0 || ua >= 1 || ub <= 0 || ub >= 1) ua = 0
        }
    }
    return ua
}