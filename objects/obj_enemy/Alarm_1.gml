
if ds_list_size(friendly_units_to_trigger) {
	var inst = friendly_units_to_trigger[|0]
	with inst {
		if other.trigger_attack_snipers_num {
			state_switch_attack_snipe(obj_looter)
			other.trigger_attack_snipers_num--
		} else
			state_switch_attack(obj_looter)
	}
	ds_list_delete(friendly_units_to_trigger, 0)
	alarm[1] = trigger_units_delay
}
