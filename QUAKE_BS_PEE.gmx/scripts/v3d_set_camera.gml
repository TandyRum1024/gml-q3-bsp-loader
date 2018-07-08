///v3d_set_camera(x,y,z,xrot,yrot,zrot);
var X = argument0;
var Y = argument1;
var Z = argument2;

var XD = argument3;
var YD = argument4;
var ZD = argument5;

C_POS[@ 0] = X;
C_POS[@ 1] = Y;
C_POS[@ 2] = Z;

C_ROT[@ 0] = XD;
C_ROT[@ 1] = YD;
C_ROT[@ 2] = ZD;

CMAT = matrix_build(X, Y, Z, XD, YD, ZD, 1, 1, 1);
v3d_update_camvector();
