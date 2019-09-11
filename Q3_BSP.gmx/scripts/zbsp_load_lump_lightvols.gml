///zbsp_load_lump_lightvols(buffer, map)
/*
    Loads lightvols lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "lightvols-data", Which referes to a ds_grid,
    with height same as the value from the map's "lightvols-num" value.
    Each row contains a data for each lightvol, With following indices:
    data[# 0-2, row] : ambient light (RGB, in 0..1 range)
    data[# 3-5, row] : directional light (RGB, in 0..1 range)
    data[# 6-7, row] : Phi & Theta angle for spherical coordinates system
    
    In order to fetch the lightvols from given x,y,z (grid) position,
    You can use 3D array indexing technique like this :
    idx = z * (xsize * ysize) + y * xsize + x
    
    And to convert from spherical coordinates to (directional) light unit vector from phi & theta :
    light_dir_x = sin(theta) * cos(phi);
    light_dir_y = sin(theta) * sin(phi);
    light_dir_z = cos(theta);
*/

var _off = argument1[? "lightvols-diroff"], _len = argument1[? "lightvols-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSP_LUMP.LIGHTVOLS], _data;
var _phimin = 360, _phimax = 0;
var _thetamin = 360, _thetamax = 0;
var _lvolgamma = true; // lightvol gamma correction
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(8, _num);
for (var i=0; i<_num; i++)
{
    // fetch colour
    var _ambr = buffer_read(argument0, buffer_u8), _ambg = buffer_read(argument0, buffer_u8), _ambb = buffer_read(argument0, buffer_u8);
    var _dirr = buffer_read(argument0, buffer_u8), _dirg = buffer_read(argument0, buffer_u8), _dirb = buffer_read(argument0, buffer_u8);
    
    if (_lvolgamma)
    {
        var _max;
        
        _ambr = _ambr << 2;
        _ambg = _ambg << 2;
        _ambb = _ambb << 2;
        _max = max(_ambr, _ambg, _ambb);
        
        if (_max > 255)
        {
            var _ratio = 255 / _max;
            _ambr *= _ratio;
            _ambg *= _ratio;
            _ambb *= _ratio;
        }
        
        _dirr = _dirr << 2;
        _dirg = _dirg << 2;
        _dirb = _dirb << 2;
        _max = max(_dirr, _dirg, _dirb);
        
        if (_max > 255)
        {
            var _ratio = 255 / _max;
            _dirr *= _ratio;
            _dirg *= _ratio;
            _dirb *= _ratio;
        }
    }
    
    // ambient colour
    _data[# 0, i] = _ambr / 255;
    _data[# 1, i] = _ambg / 255;
    _data[# 2, i] = _ambb / 255;
    
    // directional colour
    _data[# 3, i] = _dirr / 255;
    _data[# 4, i] = _dirg / 255;
    _data[# 5, i] = _dirb / 255;
    
    // phi & theta
    var _phi = buffer_read(argument0, buffer_u8);
    var _theta = buffer_read(argument0, buffer_u8);
    
    _phimin = min(_phimin, _phi); _phimax = max(_phimax, _phi);
    _thetamin = min(_thetamin, _theta); _thetamax = max(_thetamax, _theta);
    _data[# 6, i] = (_phi / 255) * 2 * pi; // phi
    _data[# 7, i] = (_theta / 255) * 2 * pi; // theta
}

show_debug_message("PHI : " + string(_phimin) + " | " + string(_phimax));
show_debug_message("THETA : " + string(_thetamin) + " | " + string(_thetamax));
argument1[? "lightvols-num"] = _num;
argument1[? "lightvols-data"] = _data;
