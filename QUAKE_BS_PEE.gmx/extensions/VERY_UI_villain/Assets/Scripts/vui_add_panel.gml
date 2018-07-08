///vui_add_panel(gui,x,y,w,h,colour,parent)

var GUI = argument0;

var X = argument1;
var Y = argument2;

var W = argument3;
var H = argument4;

var COL = argument5;
var PAR = argument6;

var INST = vui_add_element(GUI, X, Y, W, H, PAR, uiTYPE.PANEL);
INST.COL = COL;

return INST;
