///load_q3bsp( BSP )
/*
    Loads Quake 3 BSP file, and return the data.
    
    TODO ::
        - Make ENUM thing
*/

var FILE = buffer_load(argument0);//file_bin_open("czg_sude.bsp", 0);

enum eLUMP
{
    ENTITY,
    TEXTURE,
    PLANE,
    NODE,
    LEAF,
    LEAFFACE,
    LEAFBRUSH,
    MODEL,
    BRUSH,
    BRUSHSIDE,
    VERTEX,
    MESHVERT,
    EFFECT,
    FACE,
    LIGHTMAP,
    LIGHTVOL,
    VISDATA
}
/*
    Some datatypes ref.
     - int :: 4-byte, little endian
     - str[N] :: N-byte, ascii(byte) string
     - ubyte :: byte.
     - float :: 4-byte float, little endian
*/
//VARIABLES
var MAGIC = "";
var VERSION = 0;
var LUMPS = 0;
var NUMLUMP = 0;

//Vertex buffers
var vBUFFERS = ds_list_create();

//SIZE DEFINES (in bytes)
/*
    http://www.mralligator.com/q3/#Lightmaps
*/
var SIZES = 0;
// NOTE 2018 : wow this was one hell of a chore back then
// No wonder why I wrote this kinda silly stuff down there V
//The size of ENTITY and VISDATA = WHAT THE FUCK.
SIZES[ 0] = -1; //Entity = ???? (WTF) bytes
SIZES[ 1] = 72; //Tex = 64 + 4 + 4 (72) bytes
SIZES[ 2] = 16; //Plane = 12 + 4 (16) bytes
SIZES[ 3] = 36; //Node = 4 + 8 + 12 + 12 (36) bytes
SIZES[ 4] = 48; //Leaf = 4 + 4 + 12 + 12 + 4 + 4 + 4 + 4 (48) bytes
SIZES[ 5] = 4; //Leaf face = 4 bytes
SIZES[ 6] = 4; //Leaf brush = 4 bytes
SIZES[ 7] = 40; //Model = 24 + 4 + 4 + 4 + 4 (40) bytes
SIZES[ 8] = 12; //Brush = 4 + 4 + 4 (12) bytes
SIZES[ 9] = 8; //Brush side = 4 + 4 (8) bytes
SIZES[ 10] = 44; //Vertex = 12 + 12 + 16 + 4 (44) bytes
SIZES[ 11] = 4; //Mesh vertex = 4 bytes
SIZES[ 12] = 72; //Effect = 64 + 4 + 4 (72) bytes
SIZES[ 13] = 104; //Face = 32 + 24 + 24 + 24 (104) bytes
SIZES[ 14] = 49152; //Lightmap = 49152 bytes
SIZES[ 15] = 8; //Light volume = 3 + 3 + 2 (8) bytes
SIZES[ 16] = -1; //Visdata = [4 + 4 + (numClusters * bytePerClusters)] (WTF) bytes.
// Whew what a load of magic numbers
// Now I want to pat 2017 me's back

//NAME DEFINES
var nLUMP;
nLUMP[ 0] = "ENTITY";
nLUMP[ 1] = "TEXTURE";
nLUMP[ 2] = "PLANE";
nLUMP[ 3] = "NODE";
nLUMP[ 4] = "LEAF";
nLUMP[ 5] = "LEAF FACE";
nLUMP[ 6] = "LEAF BRUSH";
nLUMP[ 7] = "MODEL";
nLUMP[ 8] = "BRUSH";
nLUMP[ 9] = "BRUSH SIDE";
nLUMP[ 10] = "VERTEX";
nLUMP[ 11] = "MESH VERTEX";
nLUMP[ 12] = "EFFECT";
nLUMP[ 13] = "FACE";
nLUMP[ 14] = "LIGHTMAP";
nLUMP[ 15] = "LIGHTVOL";
nLUMP[ 16] = "VISDATA";

//DATA FOR RETURN THING
DATA = 0;

//READ THE HEADER
/*
    HEADER
        - IBSP magic word (4 ascii code)
        - Version (int)
*/

/*IBSP magic word*/
buffer_seek(FILE, buffer_seek_start, 0);
MAGIC = q3_read_str(FILE, 4);
show_debug_message("HEADER : "+MAGIC);

/*Version check*/
VERSION = q3_read_int(FILE);
show_debug_message("VERSION : "+string(VERSION));
//Q3, YAY!
if (MAGIC == "IBSP" && VERSION == $2E) show_debug_message("(IBSP & 0x2E, THE QUAKE 3 FORMAT.)");

/*Get LUMPs' data*/
//Lump have 2 ints for length and offset.
//And we've got 17 Lumps.
var tOFF,tLEN,tNUM;
// show_debug_message("-=========[LUMPS]=========-"); //MMmmmmMmmm, FANCY
for (var i=0;i<17;i++)
{
    //OFFSET
    tOFF = q3_read_int(FILE);
    //LENGTH
    tLEN = q3_read_int(FILE);
    
    LUMPS[ i, 0] = tOFF;
    LUMPS[ i, 1] = tLEN;
    // show_debug_message(string(nLUMP[@ i])+"'S OFFSET : "+string(tOFF));
    // show_debug_message(string(nLUMP[@ i])+"'S LENGTH : "+string(tLEN));
    if (i == 0 || i == 16) tNUM = -1;
    else tNUM = tLEN / SIZES[@ i];
    // show_debug_message(string(tNUM)+" ITEMS OF "+string(nLUMP[@ i])+"."); 
    
    NUMLUMP[ i] = tNUM;
    
    // show_debug_message("-=========================-");
}

/*GET VERTEX*/
/*
    float vPosition[3];      // (x, y, z) position. 
    float vTextureCoord[2];  // (u, v) texture coordinate
    float vLightmapCoord[2]; // (u, v) lightmap coordinate
    float vNormal[3];        // (x, y, z) normal vector
    byte color[4];           // RGBA color for the vertex 
*/
VERTS = q3_load_vertex(FILE, LUMPS[@ eLUMP.VERTEX, 0], LUMPS[@ eLUMP.VERTEX, 1], SIZES[@ eLUMP.VERTEX]);

/*GET MODELS*/
/*
    float[3] minsBounding box min coord.
    float[3] maxsBounding box max coord.
    int faceFirst face for model.
    int n_facesNumber of faces for model.
    int brushFirst brush for model.
    int n_brushesNumber of brushes for model.
*/
MDLS = q3_load_models(FILE, LUMPS[@ eLUMP.MODEL, 0], LUMPS[@ eLUMP.MODEL, 1], SIZES[@ eLUMP.MODEL]); 

/*GET FACES*/
/*
    int textureTexture index.
    int effectIndex into lump 12 (Effects), or -1.
    int typeFace type. 1=polygon, 2=patch, 3=mesh, 4=billboard
    int vertexIndex of first vertex.
    int n_vertexesNumber of vertices.
    int meshvertIndex of first meshvert.
    int n_meshvertsNumber of meshverts.
    int lm_indexLightmap index.
    int[2] lm_startCorner of this face's lightmap image in lightmap.
    int[2] lm_sizeSize of this face's lightmap image in lightmap.
    float[3] lm_originWorld space origin of lightmap.
    float[2][3] lm_vecsWorld space lightmap s and t unit vectors.
    float[3] normalSurface normal.
    int[2] sizePatch dimensions.
*/
FACES = q3_load_faces(FILE, LUMPS[@ eLUMP.FACE, 0], LUMPS[@ eLUMP.FACE, 1], SIZES[@ eLUMP.FACE]); 

/*GET LIGHTMAP*/
/*
    LIGHTMAPS - byte[128][128][3]
    ==================================
    They are 128x128 Textures.
*/
LMAPS = q3_load_lightmap(FILE, LUMPS[@ eLUMP.LIGHTMAP, 0], LUMPS[@ eLUMP.LIGHTMAP, 1], SIZES[@ eLUMP.LIGHTMAP], true);
numLMAPS = LUMPS[@ eLUMP.LIGHTMAP, 1] / SIZES[@ eLUMP.LIGHTMAP];

/*GET LEAFFACES*/
LFACES = q3_load_leaffaces(FILE, LUMPS[@ eLUMP.LEAFFACE, 0], LUMPS[@ eLUMP.LEAFFACE, 1], SIZES[@ eLUMP.LEAFFACE]);

/*GET MESHVERTEXES*/
MVERTS = q3_load_meshvert(FILE, LUMPS[@ eLUMP.MESHVERT, 0], LUMPS[@ eLUMP.MESHVERT, 1], SIZES[@ eLUMP.MESHVERT]);

/*GET PLANES*/
PLANES = q3_load_planes(FILE, LUMPS[@ eLUMP.PLANE, 0], LUMPS[@ eLUMP.PLANE, 1], SIZES[@ eLUMP.PLANE]);

/*GET VISDATA*/
VISDATA = q3_load_visdata(FILE, LUMPS[@ eLUMP.VISDATA, 0]);

/*GET LEAVES*/
/*
    int cluster;           // The visibility cluster 
    int area;              // The area portal 
    int mins[3];           // The bounding box min position 
    int maxs[3];           // The bounding box max position 
    int leafface;          // The first index into the face array 
    int numOfLeafFaces;    // The number of faces for this leaf 
    int leafBrush;         // The first index for into the brushes 
    int numOfLeafBrushes;  // The number of brushes for this leaf 
*/
LEAVES = q3_load_leafs(FILE, LUMPS[@ eLUMP.LEAF, 0], LUMPS[@ eLUMP.LEAF, 1], SIZES[@ eLUMP.LEAF], vBUFFERS);

//show_debug_message(string(ds_list_size(vBUFFERS))+" : Buffers");
q3_prepare_vbuffer(LEAVES, FACES, LFACES, VERTS, MVERTS, vBUFFERS, numLMAPS);

/*GET NODES*/
/*
    int plane;      // The index into the planes array 
    int front;      // The child index for the front node 
    int back;       // The child index for the back node 
    int mins[3];    // The bounding box min position. 
    int maxs[3];    // The bounding box max position. 
*/
NODES = q3_load_nodes(FILE, LUMPS[@ eLUMP.NODE, 0], LUMPS[@ eLUMP.NODE, 1], SIZES[@ eLUMP.NODE]);

//Allocate data
DATA[ 0] = LMAPS;
DATA[ 1] = numLMAPS;
DATA[ 2] = VERTS;
DATA[ 3] = FACES;
DATA[ 4] = LFACES;
DATA[ 5] = LEAVES;
DATA[ 6] = MVERTS;
DATA[ 7] = PLANES;
DATA[ 8] = VISDATA;
DATA[ 9] = NODES;
DATA[ 10] = vBUFFERS;

//file_bin_close(FILE);
return DATA;
