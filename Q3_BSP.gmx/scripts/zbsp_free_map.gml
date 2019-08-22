/// zbsp_free_map(bspdata)
///zbsp_free_map(map)
/*
    Frees given bsp map datastructure from memory
*/
var bspdata = argument0;

// Free texture related data
if (ds_exists(bspdata[? "res-tex-dir"], ds_type_list)) ds_list_destroy(bspdata[? "res-tex-dir"]);

// Free texture(s)
var _textures = bspdata[? "textures-sprites"];
for (var i=0; i<array_length_1d(_textures); i++)
{
    if (sprite_exists(_textures[| i])) sprite_delete(_textures[| i]);
}
if (ds_exists(bspdata[? "textures-list"], ds_type_list)) ds_list_destroy(bspdata[? "textures-list"]);

// Free lightmap(s)
var _lightmaps = bspdata[? "lightmaps-sprites"];
for (var i=0; i<array_length_1d(_lightmaps); i++)
{
    if (sprite_exists(_lightmaps[| i])) sprite_delete(_lightmaps[| i]);
}
if (ds_exists(bspdata[? "lightmaps-list"], ds_type_list)) ds_list_destroy(bspdata[? "lightmaps-list"]);
if (ds_exists(bspdata[? "res-lightatlas-surf"], ds_type_list)) surface_free(bspdata[? "res-lightatlas-surf"]);
if (ds_exists(bspdata[? "res-lightatlas-spr"], ds_type_list)) sprite_delete(bspdata[? "res-lightatlas-spr"]);

// Free map metadata lists
if (ds_exists(bspdata[? "meta-arena-type"], ds_type_list)) ds_list_destroy(bspdata[? "meta-arena-type"]);
if (ds_exists(bspdata[? "meta-arena-bots"], ds_type_list)) ds_list_destroy(bspdata[? "meta-arena-bots"]);

// Free map lump datas
for (var i=0; i<array_length_1d(global.BSPLumpNames); i++)
{
    switch (i)
    {
        case eBSP_LUMP.ENTITIES:
            break;
            
        case eBSP_LUMP.VISDATA:
            // Free visdata vector
            if (ds_map_exists(bspdata, "visdata") && ds_exists(bspdata[? "visdata"], ds_type_list)) ds_list_destroy(bspdata[? "visdata"]);
            break;
        
        case eBSP_LUMP.LEAFBRUSHES:
        case eBSP_LUMP.LEAFFACES:
        case eBSP_LUMP.MESHVERTS:
            // Free lump related data structures
            if (ds_map_exists(bspdata, global.BSPLumpNames[@ i] + "-data") && ds_exists(bspdata[? global.BSPLumpNames[@ i] + "-data"], ds_type_list)) ds_list_destroy(bspdata[? global.BSPLumpNames[@ i] + "-data"]);
            break;
        
        default:
            // Free lump related data structures
            if (ds_map_exists(bspdata, global.BSPLumpNames[@ i] + "-data") && ds_exists(bspdata[? global.BSPLumpNames[@ i] + "-data"], ds_type_grid)) ds_grid_destroy(bspdata[? global.BSPLumpNames[@ i] + "-data"]);
            break;
    }
}

// Free vertex buffers
if (ds_map_exists(bspdata, "vb-faces")) vertex_delete_buffer(bspdata[? "vb-faces"]);
if (ds_map_exists(bspdata, "vb-debug-bbox")) vertex_delete_buffer(bspdata[? "vb-debug-bbox"]);
if (ds_map_exists(bspdata, "vb-debug-lightlvol")) vertex_delete_buffer(bspdata[? "vb-debug-lightlvol"]);

if (ds_map_exists(bspdata, "faces-buffers"))
{
    var _facebuffers = bspdata[? "faces-buffers"];
    for (var i=0; i<ds_list_size(_facebuffers); i++)
    {
        vertex_delete_buffer(_facebuffers[| i]);
    }
}

// And free vertex formats too
vertex_format_delete(bspdata[? "vb-format-face-tex"]);
vertex_format_delete(bspdata[? "vb-format-face-notex"]);
vertex_format_delete(bspdata[? "vb-debug-format"]);

ds_map_destroy(bspdata);
