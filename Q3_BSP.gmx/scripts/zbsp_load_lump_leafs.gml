///zbsp_load_lump_leafs(buffer, map)
/*
    Loads leafs lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "leafs-data", Which refers to a ds_grid,
    with height same as the value from the map's "leafs-num" value.
    Each row contains a data for each node, With following indices:
    data[# 0, row] : Visible cluster index
    data[# 1, row] : Areaportal area
    data[# 2-4, row] : Bounding box's minimum xyz position
    data[# 5-7, row] : Bounding box's maximum xyz position
    data[# 8, row] : This leaf's first leafface index
    data[# 9, row] : numbers of leaffaces that this leaf uses
    data[# 10, row] : This leaf's first leafbrush index
    data[# 11, row] : numbers of leafbrushes that this leaf uses
*/

var _off = argument1[? "leafs-diroff"], _len = argument1[? "leafs-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.LEAFS], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(12, _num);
for (var i=0; i<_num; i++)
{
    // viscluster idx
    _data[# 0, i] = buffer_read(argument0, buffer_u32);
    
    // areaportal area
    _data[# 1, i] = buffer_read(argument0, buffer_u32);
    
    // bbox min coords
    _data[# 2, i] = buffer_read(argument0, buffer_u32);
    _data[# 3, i] = buffer_read(argument0, buffer_u32);
    _data[# 4, i] = buffer_read(argument0, buffer_u32);
    
    // bbox max coords
    _data[# 5, i] = buffer_read(argument0, buffer_u32);
    _data[# 6, i] = buffer_read(argument0, buffer_u32);
    _data[# 7, i] = buffer_read(argument0, buffer_u32);
    
    // first leafface idx
    _data[# 8, i] = buffer_read(argument0, buffer_u32);
    
    // number of leaffaces this bad boy uses
    _data[# 9, i] = buffer_read(argument0, buffer_u32);
    
    // first leafbrush idx
    _data[# 10, i] = buffer_read(argument0, buffer_u32);
    
    // *slaps the roof of leaf* this bad boy uses this much of leafbrush
    _data[# 11, i] = buffer_read(argument0, buffer_u32);
}

argument1[? "leafs-num"] = _num;
argument1[? "leafs-data"] = _data;
