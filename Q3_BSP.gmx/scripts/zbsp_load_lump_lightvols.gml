///zbsp_load_lump_lightvols(buffer, map)
/*
    Loads lightvols lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "lightvols-data", Which referes to a ds_grid,
    with height same as the value from the map's "lightvols-num" value.
    Each row contains a data for each lightvol, With following indices:
    data[# 0, row] : ambient light (#BBGGRR notation)
    data[# 1, row] : directional light (#BBGGRR notation)
    data[# 6-7, row] : Phi & Theta angle for spherical coordinates system
    
    In order to fetch the lightvols from given x,y,z (grid) position,
    You can use 3D array indexing technique like this :
    idx = z * (xsize * ysize) + y * xsize + x
*/

var _off = argument1[? "lightvols-diroff"], _len = argument1[? "lightvols-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.LIGHTVOLS], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(4, _num);
show_debug_message("FACE GRID : " + string(_data));
for (var i=0; i<_num; i++)
{
    // ambient colour
    _data[# 0, i] = buffer_read(argument0, buffer_u8) | (buffer_read(argument0, buffer_u8) << 8) | (buffer_read(argument0, buffer_u8) << 16);
    
    // directional colour
    _data[# 1, i] = buffer_read(argument0, buffer_u8) | (buffer_read(argument0, buffer_u8) << 8) | (buffer_read(argument0, buffer_u8) << 16);
    
    // phi & theta
    _data[# 2, i] = (buffer_read(argument0, buffer_u8) / 255) * 2 * pi; // phi
    _data[# 3, i] = (buffer_read(argument0, buffer_u8) / 255) * pi; // theta
}

argument1[? "lightvols-num"] = _num;
argument1[? "lightvols-data"] = _data;
