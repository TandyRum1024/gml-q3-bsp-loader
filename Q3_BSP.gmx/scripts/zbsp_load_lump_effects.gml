///zbsp_load_lump_effects(buffer, map)
/*
    Loads effects lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "effects-data", Which referes to a ds_grid,
    with height same as the value from the map's "effects-num" value.
    Each row contains a data for each brushside, With following indices:
    data[# 0, row] : Effect shader
    data[# 1, row] : Brush index that generates this effect
*/

var _off = argument1[? "effects-diroff"], _len = argument1[? "effects-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSP_LUMP.EFFECTS], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(2, _num);
for (var i=0; i<_num; i++)
{
    // effect shader string
    _data[# 0, i] = zbsp_read_str(argument0, 64);
    
    // brush index
    _data[# 1, i] = buffer_read(argument0, buffer_s32);
    
    // reserved
    buffer_read(argument0, buffer_s32);
}

argument1[? "effects-num"] = _num;
argument1[? "effects-data"] = _data;
