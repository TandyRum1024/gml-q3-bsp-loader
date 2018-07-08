///v3d_update_projection();

//SET SHIT UP
var CX = C_POS[@ 0];
var CY = C_POS[@ 1];
var CZ = C_POS[@ 2];

//Get camera vectors
//Front
var FX = CFROT[@ 0];
var FY = CFROT[@ 1];
var FZ = CFROT[@ 2];
//Up
var UX = CFROT[@ 8];
var UY = CFROT[@ 9];
var UZ = CFROT[@ 10];

//Now what
d3d_set_projection_ext(CX, CY, CZ, CX + FX, CY + FY, CZ + FZ, UX, UY, UZ, C_FOV, ASPECT, 0.01, 6974);
