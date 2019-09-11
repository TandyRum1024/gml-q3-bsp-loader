///zbsp_load_map(filename, assetdir, buildlevelmesh, builddebugmesh)
/*
    Loads Quake 3 map from zip/pk3 file, And returns ds_map containing the map information.
    =======================================================================================
    filename : direction to the Quake 3 map file. zip, pk3 and bsp files are supported.
    Feeding zip & pk3 files will make the script try to load the extra texture data & map metadata.
  
    assetdir : directory to the Quake 3's asset pk3 file. (pak00.pk3)
    If the script can't find the file and didn't detects the base assets, The script will load & use default checkerboard texture instead of Quake 3's base texture when building the level mesh.
    If there's already a 
    Textures that was included with the map's pk3 / zip files will still be used regardless.
    
    buildlevelmesh : if set to true, the script will try to generate every face's mesh data into a vertex buffer.
    Then it can be used to render the levels with the vertex buffer.
    The list of buffers can be indexed from returned ds_map with the key "vb-faces" and each faces from the list can be rendered with vertex_submit() with [pr_triangle] primitive type.
    Each face has it's texture index data (see also : zbsp_load_lump_faces() for other data's indexes)
    And you can use that to fetch it's texture (ready to passed into vertex_submit) from the ds_list indexed with the key "textures-list".
    
    builddebugmesh : if set to true, the script will generate the Bounds visualization vertex buffer and Lightvol visualization vertex buffer.
    The bounds visualization vertex buffer contains the vertex buffer containing the set of line segments that visualizes the bounds data of Nodes, Leafs and Models.
    The buffer can be indexed from returned ds_map with the key "vb-debug-bbox" and can be rendered with vertex_submit() with [pr_linelist] primitive type.
    
    The lightvol visualization vertex buffer contains the vertex buffer containing the set of triangles that visualizes the LightVol (Uniform grid of light informations) with grid of cube.
    It visualizes the lights information about ambient light, directional light and its direction with a grid of 3D cubes,
    The buffer can be indexed from returned ds_map with the key "vb-debug-lightlvol" and can be rendered with vertex_submit() with [pr_trianglelist] primitive type.
*/

// ==================================================================
/// define variables
// ==================================================================
assetdirectory = argument1;
buildlevelmesh = argument2;
builddebugmesh = argument3;

// helper variables that will help you (& me) to index the bsp map data structure
zbsp_helper_vars();

// data related variables
var bspdata = ds_map_create(); // map containing the bsp data
var _filetype = string_delete(filename_ext(argument0), 1, 1);
var _filename = string_copy(filename_name(argument0), 1, string_pos(".", filename_name(argument0)) - 1);

// setup values
bspdata[? "success"] = true;
bspdata[? "error"] = "";
bspdata[? "has-base-asset"] = true;
bspdata[? "has-map-asset"] = true;
bspdata[? "meta-filetype"] = _filetype;
bspdata[? "meta-filename"] = _filename;
bspdata[? "meta-map-name"] = _filename;
bspdata[? "meta-debug-log"] = "ZBSP_LOAD_MAP() BEGIN... FILE : [" + string(argument0) + "]#===#";

// relative directories
var _datafolder = "bspdata";
var _mapfolder = _datafolder + "\map\" + _filename;
var _assetfolder = _datafolder + "\res";
var _bspfile = "";

if (!file_exists(argument0))
{
    /// file doesn't exist : bail out
    zbsp_append_log(bspdata, "FILE NOT EXISTS... ABORT");
    
    bspdata[? "success"] = false;
    bspdata[? "error"] = "NOFILE";
    zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
    return bspdata;
}

if ((assetdirectory == -1 || !file_exists(assetdirectory)) && !directory_exists(_assetfolder))
{
    // No assets file
    zbsp_append_log(bspdata, "NO ASSET FILES FOUND");
    bspdata[? "has-base-asset"] = false;
}

// ==================================================================
/// unpack zip/pk3 file before processing
// ==================================================================

// add map resource direction to the map so we can access those later
bspdata[? "meta-res-dir"] = _mapfolder;

// Check & unpack base assets
if (bspdata[? "has-base-asset"])
{
    if (!directory_exists(_assetfolder))
    {
        zbsp_append_log(bspdata, "Unpacking base assets... this might take a while");
        show_debug_message("Unpacking base assets... this might take a while");
        
        // unzip & check if we successfully unzipped the base assets
        if (!zip_unzip(assetdirectory, _assetfolder))
        {
            bspdata[? "has-base-asset"] = false;
        }
    }
}

zbsp_append_log(bspdata, "Unpacking level...");
zbsp_append_log(bspdata, "FILETYPE : " + _filetype);
show_debug_message("Unpacking level...");

// create directory if needed
if (!directory_exists(_datafolder))
{
    directory_create(_datafolder);
    zbsp_append_log(bspdata, "Data folder not found; Making one...");
}
if (!directory_exists(_mapfolder))
{
    directory_create(_mapfolder);
    zbsp_append_log(bspdata, "Map folder not found; Making one...");
}

zbsp_append_log(bspdata, "DATA FOLDER : " + _datafolder);
show_debug_message("DATA FOLDER : " + _datafolder);

// Do appropriate processings for each given file types
var _result = 0;
switch (_filetype)
{
    case "zip": // zip files - contains pk3 which contains the bsp file and textures
        if (!directory_exists(_mapfolder + "\unzip")) directory_create(_mapfolder + "\unzip");
        
        _result |= zip_unzip(argument0, _mapfolder + "\unzip"); // unzip contents (normally map preview pictures and info)
        
        var _pk3 = file_find_first(_mapfolder + "\unzip\*.pk3", 0);
        if (_pk3 == "")
        {
            _result = false;
            show_debug_message("NO PK FILE!");
            break;
        }
        file_find_close();
        
        _result |= zip_unzip(_mapfolder + "\unzip\" + _pk3, _mapfolder); // unzip pk3 contents (normally bsp file and textures, etc)
        _result |= file_exists(_mapfolder + "\maps\" + _filename + ".bsp");
        _bspfile = _mapfolder + "\maps\" + _filename + ".bsp";
        
        bspdata[? "has-map-asset"] = true;
        break;

    default:
    case "pk3": // various pk files that contains bsp files and stuff
        _result |= zip_unzip(argument0, _mapfolder); // unzip pk3 contents (normally bsp file and textures, etc)
        _result |= file_exists(_mapfolder + "\maps\" + _filename + ".bsp");
        _bspfile = _mapfolder + "\maps\" + _filename + ".bsp";
        
        bspdata[? "has-map-asset"] = true;
        break;
        
    case "bsp":
        show_debug_message("BSP FILE");
        _result = 1;
        _bspfile = argument0;
        break;
}
if (_result == 0)
{
    /// possibly wrong file type
    zbsp_append_log(bspdata, "INVALID FILE... ABORT");
    
    bspdata[? "success"] = false;
    bspdata[? "error"] = "FILEINVALID";
    show_debug_message("ABORT");
    zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
    return bspdata;
}

// Read map related data
if (bspdata[? "has-map-asset"])
{
    // read .arena metadata for various metadatas including actual map name
    var _mapscriptdir = _mapfolder + "\scripts";
    if (directory_exists(_mapscriptdir))
    {
        var _arenadir = file_find_first(_mapscriptdir + "\*.arena", 0);
        
        if (_arenadir != "")
        {
            show_debug_message("Reading map .arena file..");
            
            var _arenafile = file_text_open_read(_mapscriptdir + "\" + _arenadir);
            var _arenacontent = "";
            while (!file_text_eof(_arenafile))
            {
                var _ln = file_text_readln(_arenafile);
                _arenacontent += _ln;
                
                // Found map's actual name
                if (string_pos("longname", _ln) != 0)
                {
                    var _quotebegin = string_pos('"', _ln);
                    var _quoteend = string_pos('"', string_delete(_ln, 1, _quotebegin));
                    var _content = string_copy(_ln, _quotebegin + 1, _quoteend - 1);
                    
                    bspdata[? "meta-arena-longname"] = _content;
                }
                
                // Found map's bsp file
                if (string_pos("map", _ln) != 0)
                {
                    var _quotebegin = string_pos('"', _ln);
                    var _quoteend = string_pos('"', string_delete(_ln, 1, _quotebegin));
                    var _content = string_copy(_ln, _quotebegin + 1, _quoteend - 1);
                    
                    bspdata[? "meta-arena-map"] = _content + ".bsp";
                    _bspfile = _mapfolder + "\maps\" + _content + ".bsp";
                }
                
                // Found map's type / tag list
                if (string_pos("type", _ln) != 0)
                {
                    var _quotebegin = string_pos('"', _ln);
                    var _quoteend = string_pos('"', string_delete(_ln, 1, _quotebegin));
                    var _content = string_copy(_ln, _quotebegin + 1, _quoteend - 1);
                    
                    // Split them into the lists
                    var _typelist = ds_list_create();
                    var _blankpos = string_pos(" ", _content);
                    
                    while (_blankpos != 0)
                    {
                        ds_list_add(_typelist, string_copy(_content, 1, _blankpos - 1));
                        _content = string_delete(_content, 1, _blankpos);
                        _blankpos = string_pos(" ", _content);
                    }
                    ds_list_add(_typelist, _content);
                    
                    bspdata[? "meta-arena-type"] = _typelist;
                }
                
                // Found map's bot list
                if (string_pos("bots", _ln) != 0)
                {
                    var _quotebegin = string_pos('"', _ln);
                    var _quoteend = string_pos('"', string_delete(_ln, 1, _quotebegin));
                    var _content = string_copy(_ln, _quotebegin + 1, _quoteend - 1);
                    
                    // Split them into the lists
                    var _botslist = ds_list_create();
                    var _blankpos = string_pos(" ", _content);
                    
                    while (_blankpos != 0)
                    {
                        ds_list_add(_botslist, string_copy(_content, 1, _blankpos - 1));
                        _content = string_delete(_content, 1, _blankpos);
                        _blankpos = string_pos(" ", _content);
                    }
                    ds_list_add(_botslist, _content);
                    
                    bspdata[? "meta-arena-bots"] = _botslist;
                }
            }
            file_text_close(_arenafile);
            
            bspdata[? "meta-arena"] = _arenacontent;
            bspdata[? "meta-map-name"] = bspdata[? "meta-arena-longname"];
        }
        else
        {
            show_debug_message("Can't find / read .arena file.. :(");
        }
    }
    
    // Fetch map's texture assets direction while walking along the map folder.
    // since this data is unused but I'm leaving this mass of data to use in other cases, You may comment this chunk of code, If you want to juice out the last bits of loading time.
    var _maptexdir = _mapfolder + "\textures";
    if (directory_exists(_maptexdir))
    {
        var _dirqueue = ds_queue_create();
        var _texdirlist = ds_list_create();
        
        ds_queue_enqueue(_dirqueue, _maptexdir);
        while (!ds_queue_empty(_dirqueue)) // Search all sub-directory for files/image
        {
            var _texdir = ds_queue_dequeue(_dirqueue);
            
            zbsp_append_log(bspdata, "DIRECTORY : " + _texdir);
            
            // Enqueue all possible directories first
            var _subdir = file_find_first(_texdir + "\*", fa_directory);
            while (_subdir != "")
            {
                if (directory_exists(_texdir + "\" + _subdir))
                {
                    zbsp_append_log(bspdata, "> SUBDIRECTORY : " + _subdir);
                    ds_queue_enqueue(_dirqueue, _texdir + "\" + _subdir);
                }
                
                _subdir = file_find_next();
            }
            file_find_close();
            
            // And find all files after that
            var _dirimg = file_find_first(_texdir + "\*.*", 0);
            while (_dirimg != "")
            {
                if (file_exists(_texdir + "\" + _dirimg))
                {
                    zbsp_append_log(bspdata, "+ FILE : " + _dirimg);
                    ds_list_add(_texdirlist, _texdir + "\" + _dirimg);
                }
                
                _dirimg = file_find_next();
            }
            file_find_close();
        }
        ds_queue_destroy(_dirqueue);
        bspdata[? "meta-res-tex-dir"] = _texdirlist;
    }
}


// ==================================================================
/// (Finally) Begin loading from BSP file
// ==================================================================
var _filebuffer = buffer_load(_bspfile);
buffer_seek(_filebuffer, buffer_seek_start, 0);

// Header
zbsp_append_log(bspdata, "[HEADER] ===================");
var _magic = zbsp_read_str(_filebuffer, 4); zbsp_append_log(bspdata, "MAGIC STRING : " + _magic); show_debug_message("MAGIC STRING : " + _magic);
var _version = buffer_read(_filebuffer, buffer_s32); zbsp_append_log(bspdata, "BSP VERSION : " + string(_version)); show_debug_message("BSP VERSION : " + string(_version));
if (_magic != "IBSP")
{
    /// possibly wrong file type
    zbsp_append_log(bspdata, "INVALID FILE... ABORT");
    
    bspdata[? "success"] = false;
    bspdata[? "error"] = "FILEINVALID";
    show_debug_message("ABORT");
    zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
    return bspdata;
}

// Lumps data
zbsp_load_lump_directory(_filebuffer, bspdata);

// Load entities data
zbsp_load_lump_entities(_filebuffer, bspdata);
var _file = file_text_open_write(_mapfolder + "\entities-dump.txt");
file_text_write_string(_file, bspdata[? "entities"]);
file_text_close(_file);

// Load textures data
show_debug_message("Loading textures..");
zbsp_load_lump_textures(_filebuffer, bspdata);

// Load plane data
show_debug_message("Loading planes..");
zbsp_load_lump_planes(_filebuffer, bspdata);

// Load node data
show_debug_message("Loading nodes..");
zbsp_load_lump_nodes(_filebuffer, bspdata);

// Load leaf data
show_debug_message("Loading leafs..");
zbsp_load_lump_leafs(_filebuffer, bspdata);

// Load leaffaces data
show_debug_message("Loading leaffaces..");
zbsp_load_lump_leaffaces(_filebuffer, bspdata);

// Load leafbrushes data
show_debug_message("Loading leafbrushes..");
zbsp_load_lump_leafbrushes(_filebuffer, bspdata);

// Load models data
show_debug_message("Loading models..");
zbsp_load_lump_models(_filebuffer, bspdata);

// Load brushes data
show_debug_message("Loading brushes..");
zbsp_load_lump_brushes(_filebuffer, bspdata);

// Load brushsides data
show_debug_message("Loading brushsides..");
zbsp_load_lump_brushsides(_filebuffer, bspdata);

// Load vertices data
show_debug_message("Loading vertices..");
zbsp_load_lump_vertices(_filebuffer, bspdata);

// Load meshverts data
show_debug_message("Loading meshverts..");
zbsp_load_lump_meshverts(_filebuffer, bspdata);

// Load effects data
show_debug_message("Loading effects..");
zbsp_load_lump_effects(_filebuffer, bspdata);

// Load faces data
show_debug_message("Loading faces..");
zbsp_load_lump_faces(_filebuffer, bspdata);

// Load lightmaps data
show_debug_message("Loading lightmaps..");
zbsp_load_lump_lightmaps(_filebuffer, bspdata);

// Load lightvols data
show_debug_message("Loading lightvols..");
zbsp_load_lump_lightvols(_filebuffer, bspdata);

// Load visdata
show_debug_message("Loading visdata..");
zbsp_load_lump_visdata(_filebuffer, bspdata);


// ==================================================================
/// Process textures information
// ==================================================================
if (bspdata[? "has-map-asset"])
{
    // Fetch & Load textures required for map
    zbsp_append_log(bspdata, "Loading textures data.. (" + string(bspdata[? "textures-num"]) + " textures)");
    show_debug_message("Loading textures data.. (" + string(bspdata[? "textures-num"]) + " textures)");
    
    // List of texture loaded into sprites & it's texture index (for use in rendering)
    bspdata[? "textures-list"] = ds_list_create();
    bspdata[? "textures-sprites"] = ds_list_create();
    
    var _textures = bspdata[? "textures-data"];
    for (var i=0; i<bspdata[? "textures-num"]; i++)
    {
        var _asset = zbsp_fetch_asset_dir(bspdata, _textures[# eBSP_TEXTURE.DIRECTORY, i] + ".jpg");
        
        if (_asset != "")
        {
            zbsp_append_log(bspdata, "Found texture [" + _asset + "]");
            show_debug_message("Found texture [" + _asset + "]");
            
            var _spr = sprite_add(_asset, 1, false, false, 0, 0);
            ds_list_add(bspdata[? "textures-sprites"], _spr);
            ds_list_add(bspdata[? "textures-list"], sprite_get_texture(_spr, 0));
        }
        else
        {
            zbsp_append_log(bspdata, "Can't find [" + _textures[# eBSP_TEXTURE.DIRECTORY, i] + "]!");
            show_debug_message("Can't find [" + _textures[# eBSP_TEXTURE.DIRECTORY, i] + "]!");
            
            ds_list_add(bspdata[? "textures-list"], sprite_get_texture(sprNotexture, 0)); // You can replace sprNotexture to a default error texture.
        }
    }
}

// ==================================================================
/// Build lightmap atlas
// ==================================================================
zbsp_append_log(bspdata, "BUILDING LIGHTMAP ATLAS (" + string(bspdata[? "lightmaps-num"]) + " TEXTURES)");
show_debug_message("BUILDING LIGHTMAP ATLAS (" + string(bspdata[? "lightmaps-num"]) + " TEXTURES)");

// List of lightmaps texture index (for use in rendering)
bspdata[? "lightmaps-list"] = ds_list_create();

// Lightmap informations and Lightmap sprites
var _lmspr = bspdata[? "lightmaps-sprites"];
var _lightinfos = bspdata[? "lightmaps-data"];

// Calculate desired lightmap texture dimensions from number of lightmaps
var _npowerw = 9, _npowerh = 9; // nth power of 2 for texture atlas' dimension, 2^9 = 512; 512x512 lightmap size for default.
var _lightmapoffsety = 10; // 10px lightmap offset for considering default, No-lightmap texture
var _lightmapmargin = 4; // Space between lightmaps, in pixel
var _lightmapunit = 128 + _lightmapmargin * 2; // size of each lightmaps

var _surfwid = 1 << _npowerw, _surfhei = 1 << _npowerh; // width / height of lightmap texture atlas
var _cols = _surfwid div _lightmapunit; // maximum columns of lightmaps we can fit in
var _rows = (_surfhei - _lightmapoffsety) div _lightmapunit; // maximum rows of lightmaps we can fit in

// Expand the lightmap texture until we can fit all the lightmaps
var _surfacegrowflip = 1;
while (_cols * _rows < bspdata[? "lightmaps-num"])
{
    if (_surfacegrowflip)
    {
        _npowerw++;
        _surfwid = 1 << _npowerw;
        _cols = _surfwid div _lightmapunit;
    }
    else
    {
        _npowerh++;
        _surfhei = 1 << _npowerh;
        _rows = (_surfhei - _lightmapoffsety) div _lightmapunit;
    }
    
    _surfacegrowflip *= -1;
}

// Calculate inverse surface sizes (for calculating texture uvs)
var _invsurfwid = 1 / _surfwid, _invsurfhei = 1 / _surfhei;

// Build lightmap
var _lmapsurf = surface_create(_surfwid, _surfhei);

surface_set_target(_lmapsurf);
draw_clear(c_black);

// Draw default / no lightmap texture
draw_sprite(sprNotexturewhite, 0, 0, 0);

// Draw the lightmaps
for (var i=0; i<bspdata[? "lightmaps-num"]; i++)
{
    var _spr = _lmspr[| i];
    ds_list_add(bspdata[? "lightmaps-list"], sprite_get_texture(_spr, 0));
    
    // draw lightmap in appropirate positions
    var _wx = (i % _cols) * _lightmapunit;
    var _wy = (i div _cols) * _lightmapunit + _lightmapoffsety;
    
    for (var o = -_lightmapmargin; o <= _lightmapmargin; o++)
    {
        draw_sprite(_spr, 0, _wx + o, _wy);
        draw_sprite(_spr, 0, _wx, _wy + o);
        draw_sprite(_spr, 0, _wx + o, _wy + o);
    }
    
    draw_sprite(_spr, 0, _wx, _wy);
    
    // calculate lightmap uvs
    _lightinfos[# eBSP_LIGHTMAP.UV_MIN_X, i] = (_wx - 1) * _invsurfwid;
    _lightinfos[# eBSP_LIGHTMAP.UV_MIN_Y, i] = (_wy - 1) * _invsurfhei;
    _lightinfos[# eBSP_LIGHTMAP.UV_MAX_X, i] = (_wx + 127) * _invsurfwid;
    _lightinfos[# eBSP_LIGHTMAP.UV_MAX_Y, i] = (_wy + 127) * _invsurfhei;
}

surface_reset_target();

bspdata[? "res-lightatlas-surf"] = _lmapsurf;
bspdata[? "res-lightatlas-spr"] = sprite_create_from_surface(_lmapsurf, 0, 0, _surfwid, _surfhei, false, false, 0, 0);
bspdata[? "res-lightatlas-tex"] = sprite_get_texture(bspdata[? "res-lightatlas-spr"], 0);

// ==================================================================
/// Calculate lightvolume dimension
// ==================================================================
var _models = bspdata[? "models-data"];
var _lightvolcellsizeh = 64; // cell size of lightvol grid in x-y axis (constant)
var _lightvolcellsizev = 128; // cell size of lightvol grid in z axis (constant)
var _lightvolnx = floor(_models[# eBSP_MODEL.BBOX_MAX_X, 0] / _lightvolcellsizeh) - ceil(_models[# eBSP_MODEL.BBOX_MIN_X, 0] / _lightvolcellsizeh) + 1;
var _lightvolny = floor(_models[# eBSP_MODEL.BBOX_MAX_Y, 0] / _lightvolcellsizeh) - ceil(_models[# eBSP_MODEL.BBOX_MIN_Y, 0] / _lightvolcellsizeh) + 1;
var _lightvolnz = floor(_models[# eBSP_MODEL.BBOX_MAX_Z, 0] / _lightvolcellsizev) - ceil(_models[# eBSP_MODEL.BBOX_MIN_Z, 0] / _lightvolcellsizev) + 1;
    
bspdata[? "lightvols-size-x"] = _lightvolnx;
bspdata[? "lightvols-size-y"] = _lightvolny;
bspdata[? "lightvols-size-z"] = _lightvolnz;
bspdata[? "lightvols-off-x"] = _models[# eBSP_MODEL.BBOX_MIN_X, 0];
bspdata[? "lightvols-off-y"] = _models[# eBSP_MODEL.BBOX_MIN_Y, 0];
bspdata[? "lightvols-off-z"] = _models[# eBSP_MODEL.BBOX_MIN_Z, 0];

// ==================================================================
/// Build debug vertex buffer / meshses
// ==================================================================
if (builddebugmesh)
{
    var _models = bspdata[? "models-data"];
    var _leafs = bspdata[? "leafs-data"];
    var _nodes = bspdata[? "nodes-data"];
    
    // Prepare vertex format
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_color();
    var _debugVF = vertex_format_end();
    var _debugVB;
    
    
    /// Build lightvol visualization vertex buffer
    // http://www.mralligator.com/q3/#Lightvols
    zbsp_append_log(bspdata, "Building Lightvol VB..");
    show_debug_message("Building Lightvol VB..");
    _debugVB = vertex_create_buffer();
    
    // list containing lightvolume
    var _lightvols = bspdata[? "lightvols-data"];
    
    var _lightvolcellsizeh = 64; // cell size of lightvol grid in x-y axis (constant)
    var _lightvolcellsizev = 128; // cell size of lightvol grid in z axis (constant)
    var _lightvolnx = bspdata[? "lightvols-size-x"];
    var _lightvolny = bspdata[? "lightvols-size-y"];
    var _lightvolnz = bspdata[? "lightvols-size-z"];
    
    zbsp_append_log(bspdata, "Lightvol entries number calculated : " + string(_lightvolnx * _lightvolny * _lightvolnz));
    zbsp_append_log(bspdata, "Lightvol actual entries according to DIRENTRY : " + string(bspdata[? "lightvols-num"]));
    show_debug_message("Lightvol entries number calculated : " + string(_lightvolnx * _lightvolny * _lightvolnz));
    show_debug_message("Lightvol actual entries according to DIRENTRY : " + string(bspdata[? "lightvols-num"]));
    
    vertex_begin(_debugVB, _debugVF);
    
    var _boxsz = 8; // size of each cube
    for (var _x=0; _x<_lightvolnx; _x++)
    {
        for (var _y=0; _y<_lightvolny; _y++)
        {
            for (var _z=0; _z<_lightvolnz; _z++)
            {
                // 3d array index for accessing lightvol from list
                var _lvolidx = _z * (_lightvolnx * _lightvolny) + _y * (_lightvolnx) + _x;
                
                // world-space position of lightvol cube
                var _wpx = bspdata[? "lightvols-off-x"] + _x * _lightvolcellsizeh, _wpy = -bspdata[? "lightvols-off-y"] - _y * _lightvolcellsizeh, _wpz = bspdata[? "lightvols-off-z"] + _z * _lightvolcellsizev;
                
                zbsp_vb_lightmapcube(_debugVB, _wpx, _wpy, _wpz, _boxsz, make_colour_rgb(_lightvols[# eBSP_LIGHTVOL.AMBIENT_R, _lvolidx] * 255, _lightvols[# eBSP_LIGHTVOL.AMBIENT_G, _lvolidx] * 255, _lightvols[# eBSP_LIGHTVOL.AMBIENT_B, _lvolidx] * 255), make_colour_rgb(_lightvols[# eBSP_LIGHTVOL.DIRECTION_R, _lvolidx] * 255, _lightvols[# eBSP_LIGHTVOL.DIRECTION_G, _lvolidx] * 255, _lightvols[# eBSP_LIGHTVOL.DIRECTION_B, _lvolidx] * 255), _lightvols[# eBSP_LIGHTVOL.PHI, _lvolidx], _lightvols[# eBSP_LIGHTVOL.THETA, _lvolidx]);
            }
        }
    }
    
    vertex_end(_debugVB);
    if (vertex_get_buffer_size(_debugVB) > 0)
    {
        vertex_freeze(_debugVB);
    }
    
    // put the vertex buffer into the map
    bspdata[? "vb-debug-lightvol"] = _debugVB;
    
    
    /// Build leaf bounding box visualization vertex buffer
    zbsp_append_log(bspdata, "Building BoundingBox VB..");
    show_debug_message("Building BoundingBox VB..");
    _debugVB = vertex_create_buffer();
    
    vertex_begin(_debugVB, _debugVF);
    
    // append models bbox data
    for (var i=0; i<bspdata[? "models-num"]; i++)
    {
        var _minx = _models[# eBSP_MODEL.BBOX_MIN_X, i], _miny = _models[# eBSP_MODEL.BBOX_MIN_Y, i], _minz = _models[# eBSP_MODEL.BBOX_MIN_Z, i];
        var _maxx = _models[# eBSP_MODEL.BBOX_MAX_X, i], _maxy = _models[# eBSP_MODEL.BBOX_MAX_Y, i], _maxz = _models[# eBSP_MODEL.BBOX_MAX_Z, i];
        
        zbsp_vb_wirecube(_debugVB, _minx, _miny, _minz, _maxx, _maxy, _maxz, c_lime, true);
    }
    
    // append nodes bbox data
    for (var i=0; i<bspdata[? "nodes-num"]; i++)
    {
        var _minx = _nodes[# eBSP_NODE.BBOX_MIN_X, i], _miny = _nodes[# eBSP_NODE.BBOX_MIN_Y, i], _minz = _nodes[# eBSP_NODE.BBOX_MIN_Z, i];
        var _maxx = _nodes[# eBSP_NODE.BBOX_MAX_X, i], _maxy = _nodes[# eBSP_NODE.BBOX_MAX_Y, i], _maxz = _nodes[# eBSP_NODE.BBOX_MAX_Z, i];
        
        zbsp_vb_wirecube(_debugVB, _minx, _miny, _minz, _maxx, _maxy, _maxz, c_lime, false);
    }
    
    // append leafs bbox data
    for (var i=0; i<bspdata[? "leafs-num"]; i++)
    {
        var _minx = _leafs[# eBSP_LEAF.BBOX_MIN_X, i], _miny = _leafs[# eBSP_LEAF.BBOX_MIN_Y, i], _minz = _leafs[# eBSP_LEAF.BBOX_MIN_Z, i];
        var _maxx = _leafs[# eBSP_LEAF.BBOX_MAX_X, i], _maxy = _leafs[# eBSP_LEAF.BBOX_MAX_Y, i], _maxz = _leafs[# eBSP_LEAF.BBOX_MAX_Z, i];
        
        zbsp_vb_wirecube(_debugVB, _minx, _miny, _minz, _maxx, _maxy, _maxz, c_lime, false);
    }
    
    vertex_end(_debugVB);
    if (vertex_get_buffer_size(_debugVB) > 0)
    {
        vertex_freeze(_debugVB);
    }
    
    // put the vertex buffer into the map
    bspdata[? "vb-debug-bbox"] = _debugVB;
    bspdata[? "vb-debug-format"] = _debugVF;
    //vertex_format_delete(_debugVF);
}


// ==================================================================
/// Build vertex buffer / meshses
// ==================================================================
if (buildlevelmesh)
{
    // Build vertex buffer of faces
    zbsp_append_log(bspdata, "Building Faces VB..");
    show_debug_message("Building Faces VB..");
    
    var _textureready = bspdata[? "has-map-asset"];
    
    // Prepare vertex format
    if (_textureready)
    {
        zbsp_vb_build_faces(bspdata);
    }
    else
    {
        zbsp_vb_build_faces_notexture(bspdata);
    }
    
    // WARNING : deleting vertex format too early & rendering the vertex buffer with deleted format will crash the game.
    //vertex_format_delete(_debugVF);
}

// Free buffer from leaking the memory
buffer_delete(_filebuffer);

zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
return bspdata;
