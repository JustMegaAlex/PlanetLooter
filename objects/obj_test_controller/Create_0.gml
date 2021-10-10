
graph = new AstarGraph()
link_len = 100

start = new Vec2d(0, 0)
finish = new Vec2d(0, 0)
path = []

for (var i = 0; i < instance_number(obj_test); ++i) {
	var inst = instance_find(obj_test, i)
	links = []
	for (var j = i + 1; j < instance_number(obj_test); ++j) {
		var _inst = instance_find(obj_test, j)
		if inst_inst_dist(inst, _inst) < link_len
			array_push(links, new Vec2d(_inst.x, _inst.y))
	}
	graph.add_node_from_point(new Vec2d(inst.x, inst.y), links)
}