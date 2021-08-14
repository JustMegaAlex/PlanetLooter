
if ds_list_size(friendly_units_to_trigger) {
	var inst = friendly_units_to_trigger[|0]
	with inst {
		state = "warmup"
		dir = inst_dir(obj_looter)
	}
	ds_list_delete(friendly_units_to_trigger, 0)
	alarm[1] = trigger_units_delay
}
