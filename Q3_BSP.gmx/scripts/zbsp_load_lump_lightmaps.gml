///zbsp_load_lump_lightmaps(buffer, map)
/*
    Loads lightmaps lump data from given buffer into the given map
    ==========================================================
    The list of 128x128 lightmap sprites can be accessed from the given map with the key "lightmaps-sprites", Which refers to a ds_list,
    with length same as the value from the map's "lightmaps-num" value.
    
    The lightmap's texture atlas related informations can be accessed from the given map with the key "lightmaps-data".
    One lightmap for each row, with following indices :
    data[# 0, row] : lightmap atlas index
    data[# 1-2, row] : lightmap uv start
    data[# 3-4, row] : lightmap uv end
*/

var _off = argument1[? "lightmaps-diroff"], _len = argument1[? "lightmaps-dirlen"];
var _num = _len / global.BSPLumpSizes[@ eBSPLUMP.LIGHTMAPS], _data, _sprites;
buffer_seek(argument0, buffer_seek_start, _off);

/// Load lightmap datas
// create list to shove lightmaps into
_sprites = ds_list_create();

// prepare vertex buffer
vertex_format_begin();
vertex_format_add_position();
vertex_format_add_color();
var _vf = vertex_format_end();
var _vb = vertex_create_buffer();

show_debug_message("LIGHTMAP BUILDING BEGIN!");
var _time = get_timer();
var _lmapoff = 16384; // lightmap's each channels size (in bytes)
var _surf = surface_create(128, 128);
for (var i=0; i<_num; i++)
{
    var _coff = _off + _lmapoff * (i * 3); // current lightmap's offset
    var _ctr = 0;
    
    surface_set_target(_surf);
    draw_clear(c_black);
    
    vertex_begin(_vb, _vf);
    // Build lightmap
    for (var j=0; j<_lmapoff; j++)
    {
        // fetch B, G, R from the file & construct the #BBGGRR formatted colour
        var _peekoff = _coff + j * 3;
        var _col = (buffer_peek(argument0, _peekoff + 2, buffer_u8) << 16) | (buffer_peek(argument0, _peekoff + 1, buffer_u8) << 8) | (buffer_peek(argument0, _peekoff, buffer_u8));
        
        // plot pixel in the lightmap
        vertex_position(_vb, j & 127, j >> 7);
        vertex_colour(_vb, _col, 1);
    }
    vertex_end(_vb);
    vertex_submit(_vb, pr_pointlist, -1);
    
    surface_reset_target();
    
    // Append lightmap
    ds_list_add(_sprites, sprite_create_from_surface(_surf, 0, 0, 128, 128, false, false, 0, 0));
    
    // (DEBUG) lightmap save
    // show_debug_message("Lightmap dumping to [" + string(argument1[? "res-dir"]) + "\lightmapdump\lmap" + string(i) + ".png]");
    if (ds_map_exists(argument1, "res-dir") && directory_exists(argument1[? "res-dir"]))
    {
        surface_save(_surf, argument1[? "res-dir"] + "\lightmapdump\lmap" + string(i) + ".png");
    }
}
show_debug_message("LIGHTMAP BUILDING DONE (" + string((get_timer() - _time) / 1000000) + "s)");

// cleanup
vertex_delete_buffer(_vb);
vertex_format_delete(_vf);
surface_free(_surf);

/// Build lightmap atlas info
_data = ds_grid_create(5, _num);
for (var i=0; i<_num; i++)
{
    // atlas idx
    _data[# 0, i] = 0;
    
    // atlas uv begin
    _data[# 1, i] = 0;
    _data[# 2, i] = 0;
    
    // atlas uv end
    _data[# 3, i] = 1;
    _data[# 4, i] = 1;
}

argument1[? "lightmaps-num"] = _num;
argument1[? "lightmaps-sprites"] = _sprites;
argument1[? "lightmaps-data"] = _data;
