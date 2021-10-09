
function Node(_point) constructor {
	point = _point
	links = []

	function add_link(node) {
		if array_find(self.links, node) { return }
		array_push(self.links, node)
	}
}

function AstarGraph() constructor {
	graph = {}

	point_to_name = function (point) {
		return "p" + string(point.X) + "_" + string(point.Y)
	}
	
	get_or_create = function(node_name, point_to_assign) {
		if variable_struct_exists(self.graph, node_name)
			return variable_struct_get(self.graph, node_name)
		var node = new Node(point_to_assign)
		variable_struct_set(self.graph, node_name, node)
		return node
	}

	add_node_from_point = function(point, link_points=[]) {
		var node_name = self.point_to_name(point)
		if array_length(link_points) == 0 {
			self.get_or_create(node_name, point)
			return
		}
		var it = new IterArray(link_points)
		while it.next() {
			var link_name = self.point_to_name(it.get())
			self.add_link_from_names(node_name, link_name, point, it.get())
		}
	}
	
	add_link_from_names = function(nm1, nm2, p1, p2) {
		var node1 = self.get_or_create(nm1, p1)
		var node2 = self.get_or_create(nm2, p2)
		node1.add_link(node2)
		node2.add_link(node1)
	}

	draw_graph = function() {
		var iter = new IterStruct(self.graph)
		while iter.next() != undefined {
			var node = iter.get()
			var p = node.point
			var _iter = new IterArray(node.links)
			while _iter.next() {
				var pp = _iter.get().point
				draw_line(p.X, p.Y, pp.X, pp.Y)
			}
		}
	}
}


