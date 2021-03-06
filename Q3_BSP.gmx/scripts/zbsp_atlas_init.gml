///zbsp_atlas_init(maxw, maxh)
/*
    Initializes some texture atlas helper code & sets the maximum texture atlas size
*/

// Variable holding currently building texture atlas surface index
zbspAtlasSurface = -1;

// Texture atlas's maximum width and height
zbspAtlasWidthMax = argument0;
zbspAtlasHeightMax = argument1;

// List that holds info about sprite / texture
/*
    0 : sprite index
    1 : atlas index
    2 : x
    3 : y
    4 : width
    5 : height
*/
zbspAtlasRectList = ds_list_create();
