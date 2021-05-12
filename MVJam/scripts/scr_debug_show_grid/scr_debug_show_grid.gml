///@arg grid
///@arg x
///@arg y
function scr_debug_show_grid(argument0, argument1, argument2) {
	var i,j,grid,x0,y0;
	grid = argument0;
	x0 = argument1;
	y0 = argument2;
	for(i=0; i<ds_grid_width(grid); i+=1)
	{
	    for(j=0; j<ds_grid_height(grid); j+=1)
	    {
	        draw_text(x0+50*i,y0+20*j,string(ds_grid_get(grid,i,j)));
	    }
	}


}
