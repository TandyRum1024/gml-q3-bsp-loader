///zbsp_load_lump_textures(buffer, map)
/*
    Loads textures lump from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "textures-data", Which referes to a ds_grid,
    with height same as the value from the map's "textures-num" value.
    Each row contains a data for each node, With following indices:
    data[# 0, row] : Texture file's directory (ex : "textures\classic2_0\metalbluecctf.jpg")
    data[# 1, row] : Texture's surface flag
    data[# 2, row] : Texture's content flag
*/

var _off = argument1[? "textures-diroff"], _len = argument1[? "textures-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.TEXTURES], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(3, _num);
for (var i=0; i<_num; i++)
{
    _data[# 0, i] = zbsp_read_str(argument0, 64); // texturename
    _data[# 1, i] = buffer_read(argument0, buffer_s32); // surface flag
    _data[# 2, i] = buffer_read(argument0, buffer_s32); // content flag
}

argument1[? "textures-num"] = _num;
argument1[? "textures-data"] = _data;
