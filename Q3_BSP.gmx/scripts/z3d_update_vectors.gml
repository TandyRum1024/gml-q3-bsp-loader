///z3d_update_vectors()
/*
    Calculates camera's up and forward vectors
*/
var _tmp;
var _hcos = dcos(camRotH), _hsin = dsin(camRotH);
var _vcos = dcos(camRotV), _vsin = dsin(camRotV);

// calculate camera forward vector
camFwdX = _vcos;
camFwdY = 0;
camFwdZ = -_vsin;

// apply horizontal rotation (z-axis rotation)
_tmp = camFwdX;
camFwdX = _tmp * _hcos;
camFwdY = _tmp * _hsin;

// Calculate up vector
camUpX = 0;
camUpY = 0;
camUpZ = 1;

// apply tilt (x-axis rotation)
_tmp = camUpY;
camUpY = _tmp * dcos(camTilt) - camUpZ * dsin(camTilt);
camUpZ = _tmp * dsin(camTilt) + camUpZ * dcos(camTilt);

// apply vertical rotation (y-axis rotation)
_tmp = camUpX;
camUpX = _tmp * _vcos + camUpZ * _vsin;
camUpZ = -_tmp * _vsin + camUpZ * _vcos;

// apply horizontal rotation (z-axis rotation)
_tmp = camUpX;
camUpX = _tmp * _hcos - camUpY * _hsin;
camUpY = _tmp * _hsin + camUpY * _hcos;
