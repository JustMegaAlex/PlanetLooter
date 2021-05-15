///scr_debug_showList(list,x,y)
function scr_debug_show_list(argument0, argument1, argument2) {
	var i,list,x0,y0;
	list = argument0;
	x0 = argument1;
	y0 = argument2;
	for(i=0; i<ds_list_size(list); i+=1)
	{
	    draw_text(x0,y0+20*i,string(ds_list_find_value(list,i)));
	}


}
