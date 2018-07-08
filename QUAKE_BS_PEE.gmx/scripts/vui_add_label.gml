///vui_add_label(gui,x,y,w,h,STR,col,parent)

var GUI = argument0;

var X = argument1;
var Y = argument2;

var W = argument3;
var H = argument4;

var STR = argument5;
var COL = argument6;

var PAR = argument7;

var INST = vui_add_element(GUI, X, Y, W, H, PAR, uiTYPE.LABEL);
INST.STR = STR;
INST.COL = COL;

return INST;
