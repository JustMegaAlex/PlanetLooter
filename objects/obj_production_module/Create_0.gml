
event_inherited()

//// ui
UI = UI_menu
ui_object = obj_ui_production_module

hp = 20
side = Sides.ours

#region production
function production_enqeue(resource_name) {
	array_push(production_qeue, resource_name)
}

function production_deqeue() {
	var res_name = production_qeue[0]
	array_delete(production_qeue, 0, 1)
	return res_name
}

function start_producing(res_name) {
	production_current_resource = res_name
	production_time_total = global.resource_types[$ res_name].production_time
	production_time_left = production_time_total
}

function do_production() {
	if production_time_left > 0 {
		--production_time_left
		if production_time_left <= 0 {
			spawn_resource_item(production_current_resource,
								x, y, spawn_resource_sp, random(360))
		}
	} else if array_length(production_qeue) {
		var res_name = production_deqeue()
		start_producing(res_name)
	}
}

// in - last element
production_qeue = []
production_time_left = 0
production_time_total = 0
production_current_resource = noone
spawn_resource_sp = 0.4
#endregion