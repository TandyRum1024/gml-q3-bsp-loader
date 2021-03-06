///zbsp_vb_lightmapcube(vb, x, y, z, size, albedocol, dircol, phi, theta)
/*
    Appends lightmap cube vertices in given vertex buffer with format [position3d, colour]
*/
var _vb = argument0;
var _x = argument1, _y = argument2, _z = argument3, _size = argument4;
var _albedocol = argument5, _dircol = argument6;
var _phi = argument7, _theta = argument8;
var _dot, _col;

// calculate light vectors
var _sint = sin(_theta), _cost = cos(_theta);
var _sinp = sin(_phi), _cosp = cos(_phi);
var _lx = _sint * _cosp;
var _ly = _sint * _sinp;
var _lz = _cost;

// build faces of cube
var _xm = _x - _size, _ym = _y - _size, _zm = _z - _size;
var _xp = _x + _size, _yp = _y + _size, _zp = _z + _size;
var _v0x = _xm, _v0y = _ym, _v0z = _zm;
var _v1x = _xp, _v1y = _ym, _v1z = _zm;
var _v2x = _xm, _v2y = _yp, _v2z = _zm;
var _v3x = _xp, _v3y = _yp, _v3z = _zm;
var _v4x = _xm, _v4y = _ym, _v4z = _zp;
var _v5x = _xp, _v5y = _ym, _v5z = _zp;
var _v6x = _xm, _v6y = _yp, _v6z = _zp;
var _v7x = _xp, _v7y = _yp, _v7z = _zp;

// Build mesh
// Face 1
_dot = zbsp_calc_lightdot(_v0x, _v0y, _v0z, _v1x, _v1y, _v1z, _v2x, _v2y, _v2z, _lx, _ly, _lz);
_col = merge_color(_albedocol, _dircol, _dot);
zbsp_vb_face(_vb, _v0x, _v0y, _v0z, _v1x, _v1y, _v1z, _v2x, _v2y, _v2z, _v3x, _v3y, _v3z, _col);

// Face 2
_dot = zbsp_calc_lightdot(_v1x, _v1y, _v1z, _v5x, _v5y, _v5z, _v3x, _v3y, _v3z, _lx, _ly, _lz);
_col = merge_color(_albedocol, _dircol, _dot);
zbsp_vb_face(_vb, _v1x, _v1y, _v1z, _v5x, _v5y, _v5z, _v3x, _v3y, _v3z, _v7x, _v7y, _v7z, _col);

// Face 3
_dot = zbsp_calc_lightdot(_v5x, _v5y, _v5z, _v4x, _v4y, _v4z, _v7x, _v7y, _v7z, _lx, _ly, _lz);
_col = merge_color(_albedocol, _dircol, _dot);
zbsp_vb_face(_vb, _v5x, _v5y, _v5z, _v4x, _v4y, _v4z, _v7x, _v7y, _v7z, _v6x, _v6y, _v6z, _col);

// Face 4
_dot = zbsp_calc_lightdot(_v4x, _v4y, _v4z, _v0x, _v0y, _v0z, _v6x, _v6y, _v6z, _lx, _ly, _lz);
_col = merge_color(_albedocol, _dircol, _dot);
zbsp_vb_face(_vb, _v4x, _v4y, _v4z, _v0x, _v0y, _v0z, _v6x, _v6y, _v6z, _v2x, _v2y, _v2z, _col);

// Face 5
_dot = zbsp_calc_lightdot(_v2x, _v2y, _v2z, _v3x, _v3y, _v3z, _v6x, _v6y, _v6z, _lx, _ly, _lz);
_col = merge_color(_albedocol, _dircol, _dot);
zbsp_vb_face(_vb, _v2x, _v2y, _v2z, _v3x, _v3y, _v3z, _v6x, _v6y, _v6z, _v7x, _v7y, _v7z, _col);

// Face 6
_dot = zbsp_calc_lightdot(_v2x, _v2y, _v2z, _v3x, _v3y, _v3z, _v6x, _v6y, _v6z, _lx, _ly, _lz);
_col = merge_color(_albedocol, _dircol, _dot);
zbsp_vb_face(_vb, _v4x, _v4y, _v4z, _v5x, _v5y, _v5z, _v0x, _v0y, _v0z, _v1x, _v1y, _v1z, _col);
