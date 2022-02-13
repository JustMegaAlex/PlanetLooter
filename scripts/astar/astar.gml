
function point_to_name(point) {
	var prefX = point.X >= 0 ? "" : "m";
	var prefY = point.Y >= 0 ? "" : "m";
	return "p" + prefX + string(abs(point.X)) + "_" + prefY + string(abs(point.Y))
}

AstarPathFindFailed = {}

function AstarGraph() constructor {
	graph = {}

	function Node(_point) constructor {
		point = _point
		links = {}
		_score = infinity
		_dist_walked = 0
		_in_boundary = false
		_dist_to_finish = 0

		add_link = function(node) {
			var name = point_to_name(node.point)
			variable_struct_set(links, name, node)
		}
		
		remove_link = function(node) {
			var name = point_to_name(node.point)
			if variable_struct_exists(links, name)
				variable_struct_remove(links, name)
		}

		_lowest_score_link = function() {
			var _score = infinity
			var chosen = noone
			var it = new IterStruct(links)
			while it.next() {
			    var n = it.value()
				if n._score == infinity
					continue
				if (n._score < _score)
					// choose bigger dist if socores are equal
				   or ((n._score == _score) and (n._dist_walked < chosen._dist_walked)) {
					_score = n._score
					chosen = n
				}
			}
			return chosen
		}
		
		_clear_score = function() {
			self._score = infinity
			_dist_walked = 0
			_in_boundary = false
			_dist_to_finish = 0
		}
	}

	get_or_create = function(point_to_assign) {
		var name = point_to_name(point_to_assign)
		if variable_struct_exists(self.graph, name)
			return variable_struct_get(self.graph, name)
		var node = new Node(point_to_assign)
		variable_struct_set(self.graph, name, node)
		return node
	}
	
	get_or_create_by_point = function(point) {
		return get_or_create(point)
	}
	
	get_by_point = function(point) {
		return variable_struct_get(self.graph, point_to_name(point))
	}
	
	check_node_by_point = function(point) {
		return variable_struct_exists(self.graph, point_to_name(point))
	}

	add_link_from_points = function(p1, p2) {
		var node1 = self.get_or_create(p1)
		var node2 = self.get_or_create(p2)
		node1.add_link(node2)
		node2.add_link(node1)
	}
	
	add_node = function(node) {
		variable_struct_set(self.graph, point_to_name(node.point), node)
	}

	add_node_from_point = function(point, link_points) {
		if link_points == undefined
			link_points = {}
		var it = new IterStruct(link_points)
		while it.next() {
			self.add_link_from_points(point, it.value())
		}
		return self.get_or_create(point)
	}
	
	remove_node = function(node) {
		var name = point_to_name(node.point)
		variable_struct_remove(graph, name)
		var it = new IterStruct(node.links)
		while it.next() {
			var _links = it.value().links
			variable_struct_remove(_links, name)
		}
	}

	// path finding

	_check_set_score = function(from, n, finish) {
		var _dist_to_finish = point_dist2d(n.point, finish.point)
		var _dist_walked = from._dist_walked + point_dist2d(from.point, n.point)
		var _score = n._dist_walked + n._dist_to_finish
		if _score < n._score {
			n._dist_to_finish = _dist_to_finish
			n._dist_walked = _dist_walked
			n._score = _score
		}
		return n._score
	}

	_find_set_lowest_score = function(node, finish) {
		var it = new IterStruct(node.links)
		var _min_score = infinity
		var chosen = noone
		while it.next() != undefined {
			var n = it.value()
			if n._in_boundary
				continue
			self._check_set_score(node, n, finish)
			if n._score < _min_score {
				chosen = n
				_min_score = n._score
			}
		}
		return chosen
	}

	_find_lowest_link_node = function(boundary, finish) {
		var it = new IterArray(boundary)
		var _min_score = infinity
		var chosen = noone
		var candidate = noone
		while it.next() != undefined {
			var n = it.get()
			candidate = self._find_set_lowest_score(n, finish)
			if candidate == noone
				continue
			if candidate._score < _min_score {
				chosen = candidate
				_min_score = chosen._score
			}
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

	clear_all_scores = function() {
		var it = new IterStruct(self.graph)
		while it.next() {
			it.value()._clear_score()	
		}
	}

	_add_to_boundary = function(boundary, node) {
		array_push(boundary, node)
		node._in_boundary = true
	}
	
	_init_start_node = function(start, boundary) {
		start._dist_walked = 0
		start._score = 0
		self._add_to_boundary(boundary, start)	
	}

	graph_find_path_points = function(start, finish) {
		// @arg start, finish - self.Node instances
		var boundary = []
		var to_clear = [start]
		self._init_start_node(start, boundary)
		var n = start
		array_expand(to_clear, start.links)
		// compute scores
		while n != finish {
			n = self._find_lowest_link_node(boundary, finish)
			// fail
			if n == noone
				return global.AstarPathFindFailed
			self._add_to_boundary(boundary, n)
			array_expand(to_clear, n.links)
			array_push(to_clear, n)
		}
		path_points = []
		path_points = self._form_path_points(start, finish)
		//self.clear_scores(to_clear)
		return path_points
	}

	closest_node_to_point = function(p) {
		var chosen = noone
		var min_dist = infinity
		var _dist = 0
		var n
		var it = new IterStruct(self.graph)
		while it.next() {
			var n = it.value()
			_dist = point_dist2d(p, n.point)
			if _dist < min_dist {
				min_dist = _dist
				chosen = n
			}
		}
		return chosen
	}

	find_path = function(pst, pend) {
		//start = self.closest_node_to_point(pst)
		//finish = self.closest_node_to_point(pend)
		start = get_or_create_by_point(pst)
		finish = get_or_create_by_point(pend)
		self.clear_all_scores()
		path = self.graph_find_path_points(start, finish)
		if path != global.AstarPathFindFailed
			array_push(path, pend)
		return path
	}

	draw_graph = function(col=c_blue) {
		var iter = new IterStruct(self.graph)
		while iter.next() != undefined {
			var node = iter.value()
			var p = node.point
			var _iter = new IterStruct(node.links)
			while _iter.next() {
				var pp = _iter.value().point
				draw_line_color(p.X, p.Y, pp.X, pp.Y, col, col)
			}
		}
	}

	clear = function() {
		graph = {}
	}
}