
i = 0
j = 0
run = false
alarm[0] = 1

function get_point(nm) {
	return variable_struct_get(global.astar_graph.graph, nm).point
}