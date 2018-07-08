///vui_add_texPanel(gui,x,y,w,h,tex,parent)

var GUI = argument0;

var X = argument1;
var Y = argument2;

var W = argument3;
var H = argument4;

var TEX = argument5;
var PAR = argument6;

var INST = vui_add_element(GUI, X, Y, W, H, PAR, uiTYPE.texPANEL);
INST.TEX = TEX;

return INST;
