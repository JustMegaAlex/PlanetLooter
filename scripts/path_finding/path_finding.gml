
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
	p = new Vec2d(left + i * gs, top + j * gs)
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
						   obj_block, false, false)
			variable_struct_set(links, point_to_name(lnk.point), lnk)
	}
	return links
}

function astar_graph_add_point(p) {
	//p = try_get_inner_point(p)
	//if p == undefined
	//	return p
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
	var path = undefined
	if nst and nend {
		path = global.astar_graph.find_path(nst.point, nend.point)
	} else {
		return global.AstarPathBlocked
	}
	if variable_struct_exists(nst, "use_once")
		global.astar_graph.remove_node(nst)
	if variable_struct_exists(nend, "use_once")
		global.astar_graph.remove_node(nend)
    if is_array(path)
        return smooth_out_path(path)
    return global.AstarPathFindFailed
}

function smooth_out_path(path) {
    if array_length(path) <= 2
        return path
    var it = new IterArray(path)
    var smooth_from = it.next()
    var new_path = [smooth_from]
    var smooth_to
    var prev_smooth_to = it.next()
    while it.next() {
        smooth_to = it.get()
        if collision_line(smooth_from.X, smooth_from.Y,
                          smooth_to.X, smooth_to.Y, obj_block, false, true) {
            array_push(new_path, prev_smooth_to)
            array_push(new_path, smooth_to)
            smooth_from = smooth_to
            prev_smooth_to = it.next()
            continue
        }
        prev_smooth_to = smooth_to
    }
    if array_back(new_path) != smooth_to {
        array_push(new_path, smooth_to)
    }
    return new_path
}

function can_be_connected(lnk1, lnk2) {
	var p = lnk1.point
	var pp = lnk2.point
	return !collision_line(p.X, p.Y, pp.X, pp.Y, obj_block, false, true)
}

function links_connectable(links) {
	var it = new IterStruct(links)
	while it.next() {
		var lnk = it.value()
		var i = 1
		while it.value(i) {
			if !can_be_connected(lnk, it.value(i))
				return false
			i++
		}
	}
	return true
}

function remove_node(graph, node) {
	var it = new IterStruct(node.links)
	while it.next() {
		var lnk = it.value()
		var i = 1
		while it.value(i) {
			var _lnk = it.value(i)
			lnk.add_link(_lnk)
			_lnk.add_link(lnk)
			lnk.remove_link(node)
			_lnk.remove_link(node)
			i++
		}
	}
	var name = point_to_name(node.point)
	variable_struct_remove(graph, name)
}

function optimize_graph(graph) {
	var it = new IterStruct(graph)
	while it.next() {
		var node = it.value()
		if links_connectable(node.links)
			remove_node(graph, node)
	}
}
