///zbsp_load_lump_leaffaces(buffer, map)
/*
    Loads leaffaces lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "leaffaces-data", Which refers to a ds_list,
    with length same as the value from the map's "leaffaces-num" value.
    The list contains the face index.
*/

var _off = argument1[? "leaffaces-diroff"], _len = argument1[? "leaffaces-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.LEAFFACES], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_list_create();
for (var i=0; i<_num; i++)
{
    // face idx
    ds_list_add(_data, buffer_read(argument0, buffer_u32));
}

argument1[? "leaffaces-num"] = _num;
argument1[? "leaffaces-data"] = _data;
