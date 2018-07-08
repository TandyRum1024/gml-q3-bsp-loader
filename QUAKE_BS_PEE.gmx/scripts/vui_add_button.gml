///vui_add_button(gui,x,y,w,h,STR,BTN_COL,TXT_COL,parent)

var GUI = argument0;

var X = argument1;
var Y = argument2;

var W = argument3;
var H = argument4;

var STR = argument5;

var BTN_COL = argument6;
var STR_COL = argument7;

var PAR = argument8;

var INST = vui_add_element(GUI, X, Y, W, H, PAR, uiTYPE.BUTTON);
INST.STR = STR;

INST.B_COL = BTN_COL;
INST.T_COL = STR_COL;

//BUTTON INDEX
INST.BTNIND = 0;

INST.HOVER = false;
INST.DOWN = false;
INST.CLICK = false;
INST.RELEASE = false;


return INST;
