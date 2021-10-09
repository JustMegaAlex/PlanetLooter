
function AstarGraph() constructor {
	graph = {}
	
	// graph building

	function Node(_point) constructor {
		point = _point
		links = []
		_score = infinity

		add_link = function(node) {
			if array_find(self.links, node) { return }
			array_push(self.links, node)
		}
		
		_lowest_score_link = function() {
			var _score = infinity
			var chosen = noone
			for (var i = 0; i < array_length(links); ++i) {
			    var n = links[i]
				if n._score < _score {
					_score = n._score
					chosen = n
				}
			}
			return n
		}
		
		_clear_score = function() { self._score = infinity}
	}

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

	add_link_from_names = function(nm1, nm2, p1, p2) {
		var node1 = self.get_or_create(nm1, p1)
		var node2 = self.get_or_create(nm2, p2)
		node1.add_link(node2)
		node2.add_link(node1)
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
	
	// path finding
	
	_get_score = function(from, n, finish) {
		return point_dist2d(from.point, n.point) 
			   + point_dist2d(n.point, finish.point)
	}
	
	_find_set_lowest_score = function(boundary, from, finish) {
		var it = new IterArray(boundary)
		var _min_score = infinity
		var chosen = noone
		while it.next() != undefined {
			var n = it.get()
			var _score = n._score
			if _score == infinity {
				_score = self._get_score(from, n, finish)
				n._score = _score
			}
			if _score < _min_score
				chosen = n
		}
		return chosen
	}
	
	_form_path_points = function(start, finish) {
		path = [finish.point]
		var n = finish
		while n != start {
			n = n._lowest_score_link()
			array_insert(path, 0, n.point)
		}
		return path
	}
	
	clear_scores = function(to_clear) {
		for (var i = 0; i < array_length(to_clear); ++i) {
		    to_clear[i]._clear_score()
		}	
	}

	graph_build_path_points = function(start, finish) {
		boundary = []
		array_expand(boundary, start.links)
		var n = noone
		var to_clear = [start]
		array_expand(to_clear, start.links)
		// compute scores
		while n != finish {
			n = self._find_set_lowest_score(boundary, finish)
			array_remove(boundary, n)
			array_expand(boundary, n.links)
			array_expand(to_clear, n.links)
			array_push(to_clear, n)
		}
		path_points = self._form_path_points(start, finish)
		self.clear_scores(to_clear)
		return path_points
	}

	closest_node_to_point = function(p) {
		var chosen = noone
		var min_dist = infinity
		var _dist = 0
		var it = new IterArray(self.graph)
		while it.next() != undefined {
			var n = it.get()
			_dist = point_dist2d(p, n.point)
			if _dist < min_dist {
				min_dist = _dist
				chosen = n
			}
		}
		return chosen
	}

	find_path = function(pst, pend) {
		start = closest_node_to_point(pst)
		finish = closest_node_to_point(pend)
		path = graph_build_path_points(start, finish)
		array_push(path, pend)
		return path
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

	clear = function() {
		graph = {}
	}
}


