///zbsp_load_lump_brushes(buffer, map)
/*
    Loads brushes lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "brushes-data", Which referes to a ds_grid,
    with height same as the value from the map's "brushes-num" value.
    Each row contains a data for each brush, With following indices:
    data[# 0, row] : Brush's first brushside index
    data[# 1, row] : Brush's number of brushsides using
    data[# 2, row] : Brush's texture index
*/

var _off = argument1[? "brushes-diroff"], _len = argument1[? "brushes-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.BRUSHES], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(3, _num);
for (var i=0; i<_num; i++)
{
    // brushside idx
    _data[# 0, i] = buffer_read(argument0, buffer_u32);
    
    // number of brushsides
    _data[# 1, i] = buffer_read(argument0, buffer_u32);
    
    // texture idx
    _data[# 2, i] = buffer_read(argument0, buffer_u32);
}

argument1[? "brushes-num"] = _num;
argument1[? "brushes-data"] = _data;
