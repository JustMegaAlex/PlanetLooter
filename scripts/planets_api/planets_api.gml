
function get_resource_block_most_close_to_surface(planet) {
	function _check_block(block) {
		return block and (block.resource_data.amount > 0)
	}
	var tmesh = planet.terrain_mesh
	var size = planet.size
	for (var dpth = 0; dpth < size / 2; ++dpth) {
	    for (var i = dpth; i < size - dpth * 2; ++i) {
		    var block = tmesh[dpth][i]
			if _check_block(block)
				return block
				
			var block = tmesh[i][dpth]
			if _check_block(block)
				return block
				
			var block = tmesh[size - dpth][i]
			if _check_block(block)
				return block
				
			var block = tmesh[i][size - dpth]
			if _check_block(block)
				return block
		}
	}
	return noone
}
