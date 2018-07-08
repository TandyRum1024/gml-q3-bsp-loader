///vui_add_element(GUI,X,Y,W,H,PAR,TYPE)
var GUI = argument0;
var X = argument1;
var Y = argument2;
var W = argument3;
var H = argument4;

var PARENT = argument5;
var TYPE = argument6;

//var GUI_ELEMENT = guiELEMENT;
//var GUID = GUI_ELEMENT[# 0,GUI];
var LIST = GUI.ITEMS;

var ELEMENT_INST = instance_create(X, Y, oGUIELEMENT);
ELEMENT_INST.OX = X;
ELEMENT_INST.OY = Y;

ELEMENT_INST.W = W;
ELEMENT_INST.H = H;

ELEMENT_INST.PAR = PARENT;
ELEMENT_INST.TYPE = TYPE;

ds_list_add(LIST, ELEMENT_INST);

return ELEMENT_INST;
