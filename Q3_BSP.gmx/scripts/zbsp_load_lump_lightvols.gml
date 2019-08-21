///zbsp_load_lump_lightvols(buffer, map)
/*
    Loads lightvols lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "lightvols-data", Which referes to a ds_grid,
    with height same as the value from the map's "lightvols-num" value.
    Each row contains a data for each lightvol, With following indices:
    data[# 0, row] : ambient light (#BBGGRR notation)
    data[# 1, row] : directional light (#BBGGRR notation)
    data[# 2-3, row] : Phi & Theta angle for spherical coordinates system
    
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
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(4, _num);
for (var i=0; i<_num; i++)
{
    // ambient colour
    _data[# 0, i] = buffer_read(argument0, buffer_u8) | (buffer_read(argument0, buffer_u8) << 8) | (buffer_read(argument0, buffer_u8) << 16);
    
    // directional colour
    _data[# 1, i] = buffer_read(argument0, buffer_u8) | (buffer_read(argument0, buffer_u8) << 8) | (buffer_read(argument0, buffer_u8) << 16);
    
    // phi & theta
    var _phi = buffer_read(argument0, buffer_u8);
    var _theta = buffer_read(argument0, buffer_u8);
    
    _phimin = min(_phimin, _phi); _phimax = max(_phimax, _phi);
    _thetamin = min(_thetamin, _theta); _thetamax = max(_thetamax, _theta);
    _data[# 2, i] = (_phi / 255) * 2 * pi; // phi
    _data[# 3, i] = (_theta / 255) * 2 * pi; // theta
}

show_debug_message("PHI : " + string(_phimin) + " | " + string(_phimax));
show_debug_message("THETA : " + string(_thetamin) + " | " + string(_thetamax));
argument1[? "lightvols-num"] = _num;
argument1[? "lightvols-data"] = _data;
