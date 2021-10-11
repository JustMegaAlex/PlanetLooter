
function AstarGraph() constructor {
	graph = {}
	
	// graph building

	function Node(_point) constructor {
		point = _point
		links = []
		_score = infinity
		_dist_walked = 0
		_in_boundary = false

		add_link = function(node) {
			if array_find(self.links, node) { return }
			array_push(self.links, node)
		}

		_lowest_score_link = function() {
			var _score = infinity
			var chosen = noone
			for (var i = 0; i < array_length(links); ++i) {
			    var n = links[i]
				if n._score == infinity
					continue
				if (n._score < _score)
					// choose bigger dist if socores are equal
				   or ((n._score == _score) and (n._dist_walked > chosen._dist_walked)) {
					_score = n._score
					chosen = n
				}
			}
			return n
		}
		
		_clear_score = function() {
			self._score = infinity
			_dist_walked = 0
			_in_boundary = false
		}
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

	_set_score = function(from, n, finish) {
		n._dist_walked = from._dist_walked + point_dist2d(from.point, n.point)
		n._score = n._dist_walked + point_dist2d(n.point, finish.point)
		return n._score
	}
	
	_find_set_lowest_score = function(node, finish) {
		/*	
			finish = {
				_score: 100,
				_in_boundary: true,
				_dist: 50,
				links: [],
				point: {X: 300, Y: 300}
			}
			node = {
				_score: 100,
				_in_boundary: true,
				_dist: 50,
				links: [a, b],
				point: {X: 0, Y: 0}
			}
			a = {
				_score: infinity, // --> 50 + 424 = 474
				_in_boundary: false,
				_dist: 0,// --> 283 + 50 = 333	
				links: [node],
				point: {X: 200, Y: 200}
			}
			b = {
				_score: infinity,// --> 50 + 224 + 224 = 488
				_in_boundary: false,
				_dist: 0, // --> 224 + 50 = 274
				links: [node],
				point: {X: 100, Y: 200}
			}
		*/
		var it = new IterArray(node.links)
		var _min_score = infinity
		var chosen = noone
		while it.next() != undefined {
			var n = it.get()
			if n._in_boundary
				continue
			if n._score == infinity
				self._set_score(node, n, finish)
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
			it.get()._clear_score()	
		}
	}

	_add_to_boundary = function(boundary, node) {
		array_push(boundary, node)
		node._in_boundary = true
	}

	graph_find_path_points = function(start, finish) {
		// @arg start, finish - self.Node instances
		start._dist_walked = 0
		start._score = 0
		var boundary = []
		var to_clear = [start]
		self._add_to_boundary(boundary, start)
		var n = start
		array_expand(to_clear, start.links)
		// compute scores
		while n != finish {
			n = self._find_lowest_link_node(boundary, finish)
			self._add_to_boundary(boundary, n)
			array_expand(to_clear, n.links)
			array_push(to_clear, n)
		}
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
		path = graph_find_path_points(start, finish)
		array_push(path, pend)
		return path
	}

	draw_graph = function() {
		var iter = new IterStruct(self.graph)
		while iter.next() != undefined {
			var node = iter.get()
			var p = node.point
			var _iter = new IterArray(node.links)
			draw_text(p.X, p.Y - 20, string(node._score))
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

//////// Tests
TEST_Astar_graph = {
	graph: new AstarGraph(),
	node: function(point, score, in_boundary, dist) {
		var n = new graph.Node(point)
		n._score = score
		n._in_boundary = in_boundary
		n._dist_walked = dist
		//n.links = links
		return n
	},
	test_find_set_lower_score: function() {
		var a, b, c, d, e, f, finish
		finish = node({X: 0, Y: 300}, infinity, false, 0)
		a = node({X: 0, Y: 0}, 0, true, 0)
		b = node({X: 50, Y: 0}, infinity, false, 0)
		a.links = [b]
		b.links = [a]
		graph.graph = [a, b]
		assert_eq(graph._find_set_lowest_score(a, finish), b)
		
		b = node({X: 50, Y: 0}, infinity, false, 0)
		c = node({X: 50, Y: 0}, infinity, false, 0)
		a.links = [b, c]
		b.links = [a]
		c.links = [a]
		graph.graph = [a, b]
		assert_eq(graph._find_set_lowest_score(a, finish), b)
		
		b = node({X: 50, Y: 0}, infinity, true, 0)
		c = node({X: 50, Y: 0}, infinity, true, 0)
		a.links = [b, c]
		b.links = [a]
		c.links = [a]
		graph.graph = [a, b]
		assert_eq(graph._find_set_lowest_score(a, finish), noone)
		
		b = node({X: 50, Y: 0}, infinity, true, 0)
		c = node({X: 50, Y: 0}, infinity, false, 0)
		a.links = [b, c]
		b.links = [a]
		c.links = [a]
		graph.graph = [a, b]
		assert_eq(graph._find_set_lowest_score(a, finish), c)
		
		b = node({X: 50, Y: 50}, infinity, false, 0)
		c = node({X: 0, Y: 50}, infinity, false, 0)
		a.links = [b, c]
		b.links = [a]
		c.links = [a]
		graph.graph = [a, b]
		assert_eq(graph._find_set_lowest_score(a, finish), c)
	},
	run_tests: function() {
		test_find_set_lower_score()
		show_debug_message("TEST_Astar_graph: all tests OK")
	}
}

TEST_Astar_graph.run_tests()

