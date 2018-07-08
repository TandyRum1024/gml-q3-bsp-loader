///v3d_update_camera();
var X = C_POS[@ 0];
var Y = C_POS[@ 1];
var Z = C_POS[@ 2];

var XD = C_ROT[@ 0];
var YD = C_ROT[@ 1];
var ZD = C_ROT[@ 2];

//CPOS = matrix_build(X, Y, Z, 0, 0, 0, 1, 1, 1);

CROT = matrix_build(0, 0, 0, XD, YD, ZD, 1 ,1 ,1);
var TEMP = matrix_build(0, 0, 0, P_TILT, 0, 0, 1 ,1 ,1);

CFROT = matrix_multiply(TEMP, CROT);
TEMP = -1;
//CMAT = matrix_multiply(CROT, CPOS);
