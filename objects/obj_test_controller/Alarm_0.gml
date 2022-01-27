
var graph = global.astar_graph.graph

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
if point_to_name(p0) == "p0_0"
	test = true
alarm[0] = 20