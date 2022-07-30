

//for (var i = 0; i < array_length(all_the_points); ++i) {
//	var p = all_the_points[i]
//	draw_circle(p.X, p.Y, 4, false)
//}

//for (var i = 0; i < array_length(inner_points_to_draw); ++i) {
//    var p = inner_points_to_draw[i]
//	draw_text(p.X, p.Y, string(p.X) + " " + string(p.Y))
//}

//var to_draw = [nodes[0]]
//var ratio = 1/100
//var k = 0
//while k != array_length(nodes)-1 {
//	var cur = nodes[k]
//	for (var i = 0; i < array_length(cur.nodes); ++i) {
//	    var link = cur.nodes[i]
//		draw_line(cur.X*ratio, cur.Y*ratio, link.X*ratio, link.Y*ratio)
//		draw_circle(link.X*ratio, link.Y*ratio, 5, false)
//	}
//	k++
//}
//for (var k = 0; k < array_length(leafs); ++k) {
//    var cur = leafs[k]
//	var link = cur.nodes[0]
//	draw_line_color(cur.X*ratio, cur.Y*ratio, link.X*ratio, link.Y*ratio, c_green, c_green)
//	draw_circle(link.X*ratio, link.Y*ratio, 5, false)
	
//	//for (var i = 0; i < array_length(cur.nodes); ++i) {
//	//    var link = cur.nodes[i]
//	//	draw_line_color(cur.X*ratio, cur.Y*ratio, link.X*ratio, link.Y*ratio, c_green, c_green)
//	//	draw_circle(link.X*ratio, link.Y*ratio, 5, false)
//	//}
//}
