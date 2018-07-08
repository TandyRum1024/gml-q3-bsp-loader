///vui_add_gui(x,y,width,height,style)
var X = argument0;
var Y = argument1;
var W = argument2;
var H = argument3;

var STYLE = argument4;
var GUI = guiELEMENT;

var ID = ds_grid_height(GUI);
ds_grid_resize(GUI, 2, ID+1);

//Instance!
var guID = instance_create(X, Y, oGUI);

//Attribute
//guID.X = X;
//guID.Y = Y;
guID.W = W;
guID.H = H;
guID.STYLE = STYLE;

//Attribute!
GUI[# 0, ID] = guID;

//Depth!

//Nudge
var INST;
for (var i=0;i<ID;i++)
{
    GUI[# 1, i]++;
    
    INST = GUI[# 0, i];
    INST.depth++;
}
GUI[# 1, ID] = 0;
guID.depth = 0;

//SUGOIIIIIIIIIIiIIIIiIIIIiiiI!
return guID;
