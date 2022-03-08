
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
		var _score = /*n.*/ _dist_walked + /*n.*/_dist_to_finish
		if _score < n._score {
			n._dist_to_finish = _dist_to_finish
			n._dist_walked = _dist_walked
			n._score = _score
		}
		return n._score
	}

	_form_path_points = function(start, finish) {
		path = [finish.point]
		var n = finish._lowest_score_link()
		while n != start {
			array_insert(path, 0, n.point)
			n = n._lowest_score_link()
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

	_find_set_lowest_score = function(node, finish) {
		var it = new IterStruct(node.links)
		var _min_score = infinity
		var chosen = noone
		while it.next() != undefined {
			var n = it.value()
			if n._in_boundary
				continue
			self._check_set_score(node, n, finish)
			// yes, nodes can repeat in DebugDrawer
			self.DebugDrawer.add_candidate(n)
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

	graph_find_path_points = function(start, finish) {
		// @arg start, finish - self.Node instances
		var boundary = []
		var to_clear = [start]
		self._init_start_node(start, boundary)
		var n = start
		array_expand(to_clear, start.links)
		self.DebugDrawer.set_chosen(start)
		self.DebugDrawer.next_iteration()
		self.DebugDrawer.add_to_boundary(start)
		// compute scores
		while n != finish {
			n = self._find_lowest_link_node(boundary, finish)
			// fail
			if n == noone
				return global.AstarPathFindFailed
			self._add_to_boundary(boundary, n)
			self.DebugDrawer.set_chosen(n)
			self.DebugDrawer.next_iteration()
			self.DebugDrawer.add_to_boundary(n)
			array_expand(to_clear, n.links)
			array_push(to_clear, n)
		}
		path_points = []
		path_points = self._form_path_points(start, finish)
		//self.clear_scores(to_clear)
		return path_points
	}

	find_path = function(pst, pend) {
		self.DebugDrawer.clear()
		var start = get_or_create_by_point(pst)
		var finish = get_or_create_by_point(pend)
		self.DebugDrawer.finish = finish
		self.clear_all_scores()
		path = self.graph_find_path_points(start, finish)
		self.DebugDrawer.finilize()
		if path != global.AstarPathFindFailed
			array_push(path, pend)
		return path
	}

	find_path_old = function(pst, pend) {
		self.DebugDrawer.clear()
		start = self.closest_node_to_point(pst)
		finish = self.closest_node_to_point(pend)
		self.DebugDrawer.finish = finish
		self.clear_all_scores()
		path = self.graph_find_path_points(start, finish)
		self.DebugDrawer.finilize()
		if path != global.AstarPathFindFailed
			array_push(path, pend)
		return path
	}

	draw_graph = function(col=c_blue) {
		var iter = new IterStruct(self.graph)
		while iter.next() != undefined {
			var node = iter.value()
			var p = node.point
			draw_circle(p.X, p.Y, 3, false)
			var _iter = new IterStruct(node.links)
			while _iter.next() {
				var pp = _iter.value().point
				//if point_in_camera(p.X, p.Y, 0) or point_in_camera(pp.X, pp.Y, 0)
				draw_line_color(p.X, p.Y, pp.X, pp.Y, col, col)
			}
		}
	}

	clear = function() {
		graph = {}
	}
	
	DebugDrawer = {
		/*
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		If adding a new method don't forget to add to self.stub_all_methods()
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		*/
		
		init_current: function() {
			return {scores: [], boundary: [], chosen: undefined}
		},
		
		iterations: [],
		current: {scores: [], boundary: [], chosen: undefined},
		finish: undefined,
		cur_i: 0,
		
		clear: function() { 
			self.iterations = []
			self.current = self.init_current()
			self.finish = undefined
		},
		
		finilize: function() {
			if array_length(iterations)
				self.current = iterations[0]
		},
		
		add_candidate: function(n) {
			array_push(self.current.scores, n)
		},
		
		add_to_boundary: function(n) {
			array_push(self.current.boundary, n)
		},
		
		set_chosen: function(n) {
			self.current.chosen = n	
		},

		next_iteration: function() {
			array_push(iterations, self.current)
			var prev = self.current
			self.current = self.init_current()
			array_expand(self.current.boundary, prev.boundary)
		},
		
		draw: function() {
			var scores = new IterArray(self.current.scores)
			var boundary = new IterArray(self.current.boundary)
			if self.current.chosen != undefined {
				var p = self.current.chosen.point
				var c = c_yellow
				draw_circle_color(p.X, p.Y, 6, c, c, false)
			}
			while scores.next() != undefined {
				var n = scores.get()
				var xx = n.point.X, yy = n.point.Y;
				draw_circle_color(xx, yy, 4, c, c, false)
				draw_text(xx, yy, string(n._score))
			}
			var c = c_green
			while boundary.next() != undefined {
				var p = boundary.get().point
				draw_circle_color(p.X, p.Y, 4, c, c, false)
			}

			if self.finish {
				var c = c_red
				var p = self.finish.point
				draw_circle_color(p.X, p.Y, 4, c, c, false)
			}
		},
		
		switch_iteration: function(step) {
			if (((cur_i + step) >= array_length(self.iterations))
					or ((cur_i + step) < 0))
				return false
			cur_i += step
			self.current = self.iterations[cur_i]
		},
		
		stub_all_methods: function() {
			var fun = function() {}
			self.finish = fun
			self.clear = fun
			self.switch_iteration = fun
			self.next_iteration = fun
			self.add_to_boundary = fun
			self.add_candidate = fun
			self.draw = fun
		},
	}
	if !global.show_path_finding_graph
		self.DebugDrawer.stub_all_methods()
}
