///zbsp_load_lump_meshverts(buffer, map)
/*
    Loads meshverts lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "meshverts-data", Which refers to a ds_list,
    with length same as the value from the map's "meshverts-num" value.
    The list contains the vertex index offset from the first vertex of the face.
*/

var _off = argument1[? "meshverts-diroff"], _len = argument1[? "meshverts-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.MESHVERTS], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_list_create();
for (var i=0; i<_num; i++)
{
    // mesh offset
    ds_list_add(_data, buffer_read(argument0, buffer_u32));
}

argument1[? "meshverts-num"] = _num;
argument1[? "meshverts-data"] = _data;
