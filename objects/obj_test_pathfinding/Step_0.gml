
if run {
	nm1 = names[i]
	nm2 = names[j]
	p1 = get_point(nm1)
	p2 = get_point(nm2)
	route = global.astar_graph.find_path(p1, p2)
	j++
	if j == len {
		j = 0
		i++
		if i == len {
			show_debug_message("Path finding graph tested: OK")
			instance_destroy()
		}
	}
}
