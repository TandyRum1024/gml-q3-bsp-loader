///zbsp_helper_vars()
/*
    Declares some helper variables that can help us to index lump & BSP's data
*/

// helper variables that will help you (& me) to index the bsp map data structure
enum eBSP_LUMP
{
    ENTITIES = 0,
    TEXTURES,
    PLANES,
    NODES,
    LEAFS,
    LEAFFACES,
    LEAFBRUSHES,
    MODELS,
    BRUSHES,
    BRUSHSIDES,
    VERTICES,
    MESHVERTS,
    EFFECTS,
    FACES,
    LIGHTMAPS,
    LIGHTVOLS,
    VISDATA
}
enum eBSP_TEXTURE // Texture data index helper
{
    DIRECTORY = 0,
    SURFACE,
    CONTENT
}
enum eBSP_PLANE // Plane data index helper
{
    NORMAL_X = 0,
    NORMAL_Y,
    NORMAL_Z,
    DISTANCE
}
enum eBSP_NODE // Node data index helper
{
    PLANE = 0,
    CHILD_FRONT,
    CHILD_BACK,
    BBOX_MIN_X,
    BBOX_MIN_Y,
    BBOX_MIN_Z,
    BBOX_MAX_X,
    BBOX_MAX_Y,
    BBOX_MAX_Z
}
enum eBSP_LEAF // Leaf data index helper
{
    VISCLUSTER = 0, // visible cluster index, Used for PVS calculating
    AREAPORTAL,
    BBOX_MIN_X,
    BBOX_MIN_Y,
    BBOX_MIN_Z,
    BBOX_MAX_X,
    BBOX_MAX_Y,
    BBOX_MAX_Z,
    LEAFFACE_IDX,
    LEAFFACE_NUM,
    LEAFBRUSH_IDX,
    LEAFBRUSH_NUM
}
enum eBSP_MODEL // Model data index helper
{
    BBOX_MIN_X = 0,
    BBOX_MIN_Y,
    BBOX_MIN_Z,
    BBOX_MAX_X,
    BBOX_MAX_Y,
    BBOX_MAX_Z,
    FACE_IDX,
    FACE_NUM,
    BRUSH_IDX,
    BRUSH_NUM
}
enum eBSP_BRUSH // Brush data index helper
{
    BRUSH_IDX = 0,
    BRUSH_NUM,
    TEXTURE
}
enum eBSP_BRUSHSIDE // Brushside data index helper
{
    PLANE_IDX = 0,
    TEXTURE
}
enum eBSP_VERTEX // Vertex data index helper
{
    X = 0,
    Y,
    Z,
    TEX_U, // texture uv
    TEX_V,
    LMAP_U, // lightmap uv
    LMAP_V,
    NORMAL_X, // normal
    NORMAL_Y,
    NORMAL_Z,
    COLOUR,
    ALPHA
}
enum eBSP_EFFECT // Effect data index helper
{
    SHADER = 0, // effect shader
    BRUSH
}
enum eBSP_FACE // Face data index helper
{
    TEXTURE = 0,
    EFFECT,
    TYPE,
    VERTEX_IDX,
    VERTEX_NUM,
    MESHVERT_IDX,
    MESHVERT_NUM,
    LIGHTMAP,
    LIGHTMAP_START_X,
    LIGHTMAP_START_Y,
    LIGHTMAP_SIZE_W,
    LIGHTMAP_SIZE_H,
    LIGHTMAP_ORIGIN_X,
    LIGHTMAP_ORIGIN_Y,
    LIGHTMAP_ORIGIN_Z,
    LIGHTMAP_VEC_S_X,
    LIGHTMAP_VEC_S_Y,
    LIGHTMAP_VEC_S_Z,
    LIGHTMAP_VEC_T_X,
    LIGHTMAP_VEC_T_Y,
    LIGHTMAP_VEC_T_Z,
    NORMAL_X,
    NORMAL_Y,
    NORMAL_Z,
    BEZIERPATCH_W,
    BEZIERPATCH_H
}
enum eBSP_FACE_TYPE // Face types
{
    POLYGON = 1,
    BEZIERPATCH,
    MESH,
    BILLBOARD
}
enum eBSP_LIGHTMAP // Lightmap data index helper
{
    ATLAS = 0,
    UV_MIN_X,
    UV_MIN_Y,
    UV_MAX_X,
    UV_MAX_Y
}
enum eBSP_LIGHTVOL // Lightvol data index helper
{
    AMBIENT_R = 0,
    AMBIENT_G,
    AMBIENT_B,
    DIRECTION_R,
    DIRECTION_G,
    DIRECTION_B,
    PHI, // spherical coordinates, phi/theta component
    THETA
}

// Define all the lump index -> string conversion table and lump size values
var _idx = 0;
global.BSPLumpNames = -1; // Lump names in string
global.BSPLumpSizes = -1; // Each lumps size in bytes
global.BSPLumpNames[_idx] = "entities"; global.BSPLumpSizes[_idx++] = 1; // entities lump has only one entry
global.BSPLumpNames[_idx] = "textures"; global.BSPLumpSizes[_idx++] = 72;
global.BSPLumpNames[_idx] = "planes"; global.BSPLumpSizes[_idx++] = 16;
global.BSPLumpNames[_idx] = "nodes"; global.BSPLumpSizes[_idx++] = 36;
global.BSPLumpNames[_idx] = "leafs"; global.BSPLumpSizes[_idx++] = 48;
global.BSPLumpNames[_idx] = "leaffaces"; global.BSPLumpSizes[_idx++] = 4;
global.BSPLumpNames[_idx] = "leafbrushes"; global.BSPLumpSizes[_idx++] = 4;
global.BSPLumpNames[_idx] = "models"; global.BSPLumpSizes[_idx++] = 40;
global.BSPLumpNames[_idx] = "brushes"; global.BSPLumpSizes[_idx++] = 12;
global.BSPLumpNames[_idx] = "brushsides"; global.BSPLumpSizes[_idx++] = 8;
global.BSPLumpNames[_idx] = "vertices"; global.BSPLumpSizes[_idx++] = 44;
global.BSPLumpNames[_idx] = "meshverts"; global.BSPLumpSizes[_idx++] = 4;
global.BSPLumpNames[_idx] = "effects"; global.BSPLumpSizes[_idx++] = 72;
global.BSPLumpNames[_idx] = "faces"; global.BSPLumpSizes[_idx++] = 104;
global.BSPLumpNames[_idx] = "lightmaps"; global.BSPLumpSizes[_idx++] = 49152;
global.BSPLumpNames[_idx] = "lightvols"; global.BSPLumpSizes[_idx++] = 8;
global.BSPLumpNames[_idx] = "visdata"; global.BSPLumpSizes[_idx++] = 1; // visdata lump has only one entry
