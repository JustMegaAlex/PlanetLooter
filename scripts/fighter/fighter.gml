
function ComponentAIMovement(
		sp_max_,
		acc_,
		dist_target_slow_down_,
		dist_switch_target_point_,
		dist_destination_reached_
) constructor {
	sp_max = sp_max_
	acc = acc_
	dist_target_slow_down = dist_target_slow_down_
	dist_switch_route_point = dist_switch_target_point_
	dist_destination_reached = dist_destination_reached_

	sp = 0
	sp_to = 0
	target_point = null
	path_finder = null
	route = {
		current: null,
		last: null,
		first: null
	}
	dist_target = 0

	use_route = false
	is_destination_reached = true

	collision_obj = obj_block

	function init_movement(p) {
		self.target_point = p
		self.is_destination_reached = false
	}

	function update_velocity(vel, pos, dir) {
		if self.is_destination_reached {
			self.sp = approach(self.sp, 0, self.acc)
			vel.set_polar(self.sp, dir)
			return;
		}

		self.dist_target = point_dist2d(pos, self.target_point)
		if self.use_route {
			self.update_route_state(pos)
		}
		self.sp_to = self.get_sp_to(pos)
		self.sp = approach(self.sp, self.sp_to, self.acc)
		// set initial value
		vel.set_polar(self.sp, dir)
		// update via avoiding
		global.AIVelocity.update_velocity_avoid_obstacles_v2(vel, pos, dir, self.sp_max, self.collision_obj)
		// don't change speed
		vel.normalize(sp)

		if self.dist_target < self.dist_destination_reached {
			self.is_destination_reached = true
			self.target_point = null
		}
	}
	
	function update_route_state(pos) {
		var p = route.current.point
		if (point_dist2d(p, pos) < self.dist_switch_route_point
				and route.current.next) {
			route_current = route.current.next
		}
	}
	
	function get_sp_to(pos) {
		if self.dist_target < self.dist_destination_reached
			return 0
		if self.dist_target < self.dist_target_slow_down
			return self.dist_target / self.dist_target_slow_down * sp_max
		return sp_max
	}
	
	function destination_reached() { return self.is_destination_reached }
}
