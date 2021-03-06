///zbsp_load_lump_faces(buffer, map)
/*
    Loads faces lump data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "faces-data", Which referes to a ds_grid,
    with height same as the value from the map's "faces-num" value.
    Each row contains a data for each face, With following indices:
    data[# 0, row] : Texture index
    data[# 1, row] : Effect index OR -1
    data[# 2, row] : Face type [1 = polygon, 2 = bezierpatch, 3 = mesh, 4 = billboard]
    data[# 3, row] : First vertex index
    data[# 4, row] : Number of vertices used
    data[# 5, row] : First meshvert index
    data[# 6, row] : Number of meshverts used
    data[# 7, row] : Lightmap index
    data[# 8-9, row] : Face's lightmap corner in lightmap (???)
    data[# 10-11, row] : Face's lightmap size in lightmap (???)
    data[# 12-14, row] : Lightmap worldspace origin
    data[# 15-17, row] : Lightmap worldspace s unit vector (s/t vectors can be used with worldspace origin to get worldspace coordinates for lightmap baking)
    data[# 18-20, row] : Lightmap worldspace t unit vector
    data[# 21-23, row] : Face's surface normal
    data[# 24-25, row] : Bezier patch dimensions
*/

var _off = argument1[? "faces-diroff"], _len = argument1[? "faces-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSP_LUMP.FACES], _data;
buffer_seek(argument0, buffer_seek_start, _off);

_data = ds_grid_create(26, _num);
for (var i=0; i<_num; i++)
{
    // texture idx
    _data[# 0, i] = buffer_read(argument0, buffer_s32);
    
    // effect idx
    _data[# 1, i] = buffer_read(argument0, buffer_s32);
    
    // face type
    _data[# 2, i] = buffer_read(argument0, buffer_s32);
    
    // first vertex idx
    _data[# 3, i] = buffer_read(argument0, buffer_s32);
    // vertex num
    _data[# 4, i] = buffer_read(argument0, buffer_s32);
    
    // first meshvert idx
    _data[# 5, i] = buffer_read(argument0, buffer_s32);
    // meshvert num
    _data[# 6, i] = buffer_read(argument0, buffer_s32);
    
    // lightmap index
    _data[# 7, i] = buffer_read(argument0, buffer_s32);
    
    // lightmap corner pos
    _data[# 8, i] = buffer_read(argument0, buffer_s32);
    _data[# 9, i] = buffer_read(argument0, buffer_s32);
    
    // lightmap size
    _data[# 10, i] = buffer_read(argument0, buffer_s32);
    _data[# 11, i] = buffer_read(argument0, buffer_s32);
    
    // lightmap worldspace origin
    _data[# 12, i] = buffer_read(argument0, buffer_f32);
    _data[# 13, i] = buffer_read(argument0, buffer_f32);
    _data[# 14, i] = buffer_read(argument0, buffer_f32);
    
    // lightmap s/t vectors
    _data[# 15, i] = buffer_read(argument0, buffer_f32);
    _data[# 16, i] = buffer_read(argument0, buffer_f32);
    _data[# 17, i] = buffer_read(argument0, buffer_f32);
    
    _data[# 18, i] = buffer_read(argument0, buffer_f32);
    _data[# 19, i] = buffer_read(argument0, buffer_f32);
    _data[# 20, i] = buffer_read(argument0, buffer_f32);
    
    // surface normal
    _data[# 21, i] = buffer_read(argument0, buffer_f32);
    _data[# 22, i] = buffer_read(argument0, buffer_f32);
    _data[# 23, i] = buffer_read(argument0, buffer_f32);
    
    // bezier patch dimensions
    _data[# 24, i] = buffer_read(argument0, buffer_s32);
    _data[# 25, i] = buffer_read(argument0, buffer_s32);
}

argument1[? "faces-num"] = _num;
argument1[? "faces-data"] = _data;
