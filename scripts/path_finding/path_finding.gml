
function initialize_path_finding() {
	global.astar_graph = new AstarGraph()
	global.astar_graph_inner = new AstarGraph()
}

function node_gather_links(node, graph) {
	var links = {}
	var all_nodes = new IterStruct(graph)
	while all_nodes.next() {
		var lnk = all_nodes.value()
		if !collision_line(node.point.X, node.point.Y,
						   lnk.point.X, lnk.point.Y,
						   obj_planet_mask, false, false)
			variable_struct_set(links, point_to_name(lnk.point), lnk)
	}
	return links
}

function astar_graph_add_point(p) {
	if global.astar_graph.check_node_by_point(p)
		return global.astar_graph.get_by_point(p)
	var node = new global.astar_graph.Node(p)
	node.links = node_gather_links(node, global.astar_graph.graph)
	global.astar_graph.add_node(node)
	var it = new IterStruct(node.links)
	while it.next() {
		var lnk = it.value()
		lnk.add_link(node)
	}
	return node
}

function astar_find_path(st, end_) {
	var nst = astar_graph_add_point(st)
	var nend = astar_graph_add_point(end_)
	var path = global.astar_graph.find_path(st, end_)
	global.astar_graph.remove_node(nst)
	global.astar_graph.remove_node(nend)
	return path
}