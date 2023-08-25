
event_inherited()

function set_hit(attacker, weapon) {
	//if !global.no_damage
	//	hp -= weapon.damage
    //var trigger_friends = array_find_ind(["attack", "attack_snipe"], state) == -1
	//set_dir_to(point_direction(x, y, obj_looter.x, obj_looter.y))
	////trigger_friendly_units()
	//if hp <= 0 {
	//	instance_destroy()
	//}
}

friendly_units_to_trigger = ds_list_create()
function trigger_friendly_units() {
	/*
	see alarm[1]
	*/
	if global.ai_attack_off { return }

	ds_list_empty(friendly_units_to_trigger)
	collision_circle_list(x, y, trigger_radius_on_detection,
						  obj_enemy, false, true,
						  friendly_units_to_trigger, false)
	trigger_attack_snipers_num = floor(ds_list_size(friendly_units_to_trigger)
									   * attack_formation_snipers_fract)
	alarm[1] = trigger_units_delay
}

//// behavior
is_moving_object = true
is_collecting_things = false
position = new Vec2d(x, y)
velocity = new Vec2d(0, 0)
acc = 0.25
dir = 0
dir_to = 0
rot_sp = 5
xst = x
yst = y
hp = 7
side = Sides.theirs
use_weapon = "pulse_spread"

state = "idle"
target_point = null
CmpMovement = new ComponentAIMovement(
    sp_max,        // sp_max_
    acc,           // acc_
    200,           // dist_target_slow_down
    40,            // dist_switch_target_point_
    sp_max * 2     // dist_destination_reached_
)

reloading = 0
weapon.reload_time = 25
