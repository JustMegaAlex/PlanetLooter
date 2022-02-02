
global.AstarPathBlocked = {}

function initialize_path_finding() {
	global.astar_graph = new AstarGraph()
	global.astar_graph_inner = new AstarGraph()
}

function get_inner_point(point, planet) {
	var p = point
	if collision_point(p.X, p.Y, obj_block, false, false)
		return undefined
	var gs = global.grid_size
	var left = planet.left_coord() + gs * 0.5
	var top = planet.top_coord() + gs * 0.5
	var i = (p.X - left) div gs
	var j = (p.Y - top) div gs
	var p = new Vec2d(left + i * gs, top + j * gs)
	return p
}

function try_get_inner_point(p) {
	var planet_mask = collision_point(p.X, p.Y, obj_planet_mask, false, false)
	if planet_mask == noone
		return p
	p = get_inner_point(p, planet_mask.planet_inst)
	return p
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
	p = try_get_inner_point(p)
	if p == undefined
		return p
	if global.astar_graph.check_node_by_point(p)
		return global.astar_graph.get_by_point(p)
	var node = new global.astar_graph.Node(p)
	node.use_once = true
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
	if nst == undefined or nend == undefined
		return global.AstarPathBlocked
	var path = global.astar_graph.find_path(st, end_)
	if variable_struct_exists(nst, "use_once")
		global.astar_graph.remove_node(nst)
	if variable_struct_exists(nend, "use_once")
		global.astar_graph.remove_node(nend)
	return path
}