
graph = new AstarGraph()
global.astar_graph = graph
link_len = 100

start = new Vec2d(0, 0)
finish = new Vec2d(0, 0)
path = []

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

iter0 = new IterStruct(graph.graph)
iter0.next()
iter1 = new IterStruct(iter0.value().links)
p0 = iter0.value().point
if !iter1.next() {
	if !iter0.next() {
		iter0 = new IterStruct(graph)
		iter0.next()
	}
	p0 = iter0.value().point
	iter1 = new IterStruct(iter0.value().links)
	iter1.next()
}
p1 = iter1.value().point

alarm[0] = 20