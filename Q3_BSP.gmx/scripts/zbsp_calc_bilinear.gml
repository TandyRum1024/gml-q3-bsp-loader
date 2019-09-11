///zbsp_calc_bilinear(x, y, z, w, u, v)
/*
    Interpolates between values (x, y, z, w) by (u, v)... like the following :
    x---u--y
    |   |  |
    v---+--v
    |   |  |
    z---u--w
*/
var _x = argument0, _y = argument1, _z = argument2, _w = argument3;
var _u = argument4, _v = argument5;

// interpolate top & bottom values (x->y, z->w)
var _vt = lerp(_x, _y, _u);
var _vb = lerp(_z, _w, _u);

// interpolate final value from above values (top->bottom)
return lerp(_vt, _vb, _v);
