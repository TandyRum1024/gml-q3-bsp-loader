/// zbsp_free_map(bspdata)
///zbsp_free_map(map)
/*
    Frees given bsp map datastructure from memory
*/
var bspdata = argument0;

// Free texture atlas related data
if (ds_exists(bspdata[? "res-tex-dir"], ds_type_list)) ds_list_destroy(bspdata[? "res-tex-dir"]);
if (surface_exists(bspdata[? "res-texatlas"])) surface_free(bspdata[? "res-texatlas"]);

// Free lightmap(s)
var _lightmaps = bspdata[? "lightmaps-data"];
for (var i=0; i<array_length_1d(_lightmaps); i++)
{
    if (surface_exists(_lightmaps[| i])) surface_free(_lightmaps[| i]);
}

for (var i=0; i<array_length_1d(global.BSPLumpNames); i++)
{
    switch (i)
    {
        case eBSPLUMP.LEAFBRUSHES:
        case eBSPLUMP.LEAFFACES:
        case eBSPLUMP.MESHVERTS:
        case eBSPLUMP.LIGHTMAPS:
            // Free lump related data structures
            if (ds_map_exists(bspdata, global.BSPLumpNames[@ i] + "-data") && ds_exists(bspdata[? global.BSPLumpNames[@ i] + "-data"], ds_type_list)) ds_list_destroy(bspdata[? global.BSPLumpNames[@ i] + "-data"]);
            break;
        
        default:
            // Free lump related data structures
            if (ds_map_exists(bspdata, global.BSPLumpNames[@ i] + "-data") && ds_exists(bspdata[? global.BSPLumpNames[@ i] + "-data"], ds_type_grid)) ds_grid_destroy(bspdata[? global.BSPLumpNames[@ i] + "-data"]);
            break;
    }
}
