///z3d_accelerate(accel, maxvel, wishdirx, wishdiry, wishdirz)
/*
    Accelerates in given direction
*/
var _accel = argument0, _maxvel = argument1;
var _wishdirx = argument2, _wishdiry = argument3, _wishdirz = argument4;

var _fwdvel = dot_product_3d(camVX, camVY, camVZ, _wishdirx, _wishdiry, _wishdirz);
var _addvel = min(_accel, _maxvel - _fwdvel);

camVX += _wishdirx * _addvel;
camVY += _wishdiry * _addvel;
camVZ += _wishdirz * _addvel;
