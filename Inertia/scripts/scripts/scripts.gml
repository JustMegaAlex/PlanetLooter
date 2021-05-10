// Script assets have changed for v2.3.0 see
// https://help.yoyogames.com/hc/en-us/articles/360005277377 for more information
function instance_create_many(x, y, layer, obj, num){
	repeat num {
		instance_create_layer(x, y, layer, obj)	
	}
}