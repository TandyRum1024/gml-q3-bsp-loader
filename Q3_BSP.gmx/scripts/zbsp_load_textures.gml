///zbsp_load_textures(buffer, map)
/*
    Loads textures lump from given buffer into the given map
*/

var _off = argument1[? "textures-diroff"], _len = argument1[? "textures-dirlen"];
var _num = _len / 72, _data;
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
