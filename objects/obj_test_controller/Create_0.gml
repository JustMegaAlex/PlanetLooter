
is_test = room == rm_test

if is_test {
	graph = new AstarGraph()
	global.astar_graph = graph
	var link_len = 100
	for (var i = 0; i < instance_number(obj_test); ++i) {
		var inst = instance_find(obj_test, i)
		links = {}
		for (var j = i + 1; j < instance_number(obj_test); ++j) {
			var _inst = instance_find(obj_test, j)
			if inst_inst_dist(inst, _inst) < link_len {
				var p = new Vec2d(_inst.x, _inst.y)
				variable_struct_set(links, point_to_name(p), p)
			}
		}
		graph.add_node_from_point(new Vec2d(inst.x, inst.y), links)
	}
} else {
	graph = global.astar_graph
}

start = new Vec2d(0, 0)
finish = new Vec2d(0, 0)
path = []
