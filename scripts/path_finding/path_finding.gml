
function node_gather_links(node, graph) {
	var links = []
	var all_nodes = new IterStruct(graph)
	while all_nodes.next() {
		var lnk = all_nodes.value()
		if !collision_line(node.point.X, node.point.Y,
						   lnk.point.X, lnk.point.Y,
						   obj_planet_mask, false, false)
			array_push(links, lnk)
	}
	return links
}

function astar_graph_add_point(p) {
	if global.astar_graph.check_node_by_point(p)
		return global.astar_graph.get_by_point(p)
	var node = global.astar_graph.add_node_from_point(p, [])
	node.links = node_gather_links(node, global.astar_graph.graph)
	return node
}

function astar_find_path(st, nd) {
	astar_graph_add_point(st)
	astar_graph_add_point(nd)
	return global.astar_graph.find_path(st, nd)
}