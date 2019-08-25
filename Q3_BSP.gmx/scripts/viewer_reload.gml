#define viewer_reload
if (ds_exists(map, ds_type_map) && BSPMapLoaded)
{
    zbsp_free_map(map);
}

viewer_load();

ds_list_clear(pvsFacesVisible);
ds_list_clear(pvsLeafsVisible);

// PVS related
pvsClusterCurrent = 0; // current visible cluster index. recalculate PVS when this value is different from previous one
pvsClusterPrevious = 0;

pvsLeafsCulled = 0;
pvsLeafCurrent = 0;

// list to store whether if we have already drawn the face
mapFacesDrawn = -1;
for (var i=0; i<map[? "faces-num"]; i++)
{
    mapFacesDrawn[i] = false;
}


#define viewer_load
// Load base asset & BSP
if (drawNoTexture)
{
    //zbsp_reset_baseassets(-1);
    
    show_debug_message("Loading map");
    map = zbsp_load_map(BSPMapDir, -1, false, true);
    
    if (map[? "success"])
    {
        show_debug_message("Building mesh");
        if (drawLeafBatch)
        {
            zbsp_vb_build_leafs_notexture(map);
            BSPMapVB = map[? "vb-leafs"];
        }
        else
        {
            zbsp_vb_build_faces_notexture(map);
            BSPMapVB = map[? "vb-faces"];
        }
    }
    else
    {
        show_debug_message("Level loading failed");
    }
}
else
{
    if (BSPAssetsDir != -1)
    {
        show_debug_message("Loading assets");
        zbsp_reset_baseassets(BSPAssetsDir);
    }
    
    show_debug_message("Loading map");
    map = zbsp_load_map(BSPMapDir, -1, true, true);
    BSPMapVB = map[? "vb-faces"];
}

if (map[? "success"])
{
    BSPMapLoaded = true;
    BSPMapLeafs = map[? "leafs-data"];
    BSPMapFaces = map[? "faces-data"];
    BSPMapLeafFaces = map[? "leaffaces-data"];
    
    show_debug_message("Map loading done");
}
else
{
    BSPMapLoaded = false;
    show_debug_message("Map loading error");
}