///zbsp_load_map(filename)
/*
    Loads Quake 3 map from zip/pk3 file, And returns ds_map containing the map information.
*/

// ==================================================================
/// define variables
// ==================================================================
// helper variables that will help you (& me) to index the bsp map data structure
enum eBSPLUMP
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
var _idx = 0;
global.BSPLumpNames = -1; // Lump names in string
global.BSPLumpSizes = -1; // Each lumps size in bytes
global.BSPLumpNames[_idx] = "entities"; global.BSPLumpSizes[_idx++] = 1;
global.BSPLumpNames[_idx] = "textures"; global.BSPLumpSizes[_idx++] = 72;
global.BSPLumpNames[_idx] = "planes"; global.BSPLumpSizes[_idx++] = 16;
global.BSPLumpNames[_idx] = "nodes"; global.BSPLumpSizes[_idx++] = 36;
global.BSPLumpNames[_idx] = "leafs"; global.BSPLumpSizes[_idx++] = 48;
global.BSPLumpNames[_idx] = "leaffaces"; global.BSPLumpSizes[_idx++] = 4;
global.BSPLumpNames[_idx] = "leafbrushes"; global.BSPLumpSizes[_idx++] = 4;
global.BSPLumpNames[_idx] = "models"; global.BSPLumpSizes[_idx++] = 40;
global.BSPLumpNames[_idx] = "brushes"; global.BSPLumpSizes[_idx++] = 12;
global.BSPLumpNames[_idx] = "brushsides"; global.BSPLumpSizes[_idx++] = 8;
global.BSPLumpNames[_idx] = "vertices"; global.BSPLumpSizes[_idx++] = 14;
global.BSPLumpNames[_idx] = "meshverts"; global.BSPLumpSizes[_idx++] = 4;
global.BSPLumpNames[_idx] = "effects"; global.BSPLumpSizes[_idx++] = 72;
global.BSPLumpNames[_idx] = "faces"; global.BSPLumpSizes[_idx++] = 26;
global.BSPLumpNames[_idx] = "lightmaps"; global.BSPLumpSizes[_idx++] = 49152;
global.BSPLumpNames[_idx] = "lightvols"; global.BSPLumpSizes[_idx++] = 8;
global.BSPLumpNames[_idx] = "visdata"; global.BSPLumpSizes[_idx++] = 1;

// data related variables
var bspdata = ds_map_create(); // map containing the bsp data
var _filetype = string_delete(filename_ext(argument0), 1, 1);
var _filename = string_copy(filename_name(argument0), 1, string_pos(".", argument0) - 1);

// setup values
bspdata[? "success"] = true;
bspdata[? "error"] = "";
bspdata[? "filetype"] = _filetype;
bspdata[? "filename"] = _filename;
bspdata[? "map-name"] = _filename;
bspdata[? "debug_log"] = "ZBSP_LOAD_MAP() BEGIN... FILE : [" + string(argument0) + "]#===#";

if (!file_exists(argument0))
{
    /// file doesn't exist : bail out
    zbsp_append_log(bspdata, "FILE NOT EXISTS... ABORT");
    
    bspdata[? "success"] = false;
    bspdata[? "error"] = "NOFILE";
    zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
    return bspdata;
}

// ==================================================================
/// unpack zip/pk3 file before processing
// ==================================================================
var _datafolder = "bspdata";
var _mapfolder = _datafolder + "\map\" + _filename;
var _assetfolder = _datafolder + "\res";
var _bspfile = "";

if (!directory_exists(_assetfolder))
{
    zbsp_append_log(bspdata, "Unpacking base assets... this might take a while");
    show_debug_message("Unpacking base assets... this might take a while");
    
    zip_unzip("oa_assets.pk3", _assetfolder);
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

// Do appropriate processings for each given file types
var _result = 0;
switch (_filetype)
{
    case "zip": // zip files - contains pk3 which contains the bsp file and textures
        if (!directory_exists(_mapfolder + "\unzip")) directory_create(_mapfolder + "\unzip");
        
        _result |= zip_unzip(argument0, _mapfolder + "\unzip"); // unzip contents (normally map preview pictures and info)
        _result |= zip_unzip(_mapfolder + "\unzip\" + _filename + ".pk3", _mapfolder); // unzip pk3 contents (normally bsp file and textures, etc)
        _result |= file_exists(_mapfolder + "\maps\" + _filename + ".bsp");
        _bspfile = _mapfolder + "\maps\" + _filename + ".bsp";
        break;

    default:
    case "pk3": // various pk files that contains bsp files and stuff
        _result |= zip_unzip(argument0, _mapfolder); // unzip pk3 contents (normally bsp file and textures, etc)
        _result |= file_exists(_mapfolder + "\maps\" + _filename + ".bsp");
        _bspfile = _mapfolder + "\maps\" + _filename + ".bsp";
        break;
        
    case "bsp":
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
    zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
    return bspdata;
}

// Read map related data
// map description
var _mapscriptdir = _mapfolder + "\scripts";
if (directory_exists(_mapscriptdir))
{
    var _arenadir = _mapscriptdir + "\" + _filename + ".arena";
    
    if (file_exists(_arenadir))
    {
        show_debug_message("Reading map .arena file..");
        
        var _arenafile = file_text_open_read(_arenadir);
        while (!file_text_eof(_arenafile))
        {
            var _ln = file_text_readln(_arenafile);
            
            if (string_pos("longname", _ln) != 0)
            {
                var _quotebegin = string_pos('"', _ln);
                var _quoteend = string_pos('"', string_delete(_ln, 1, _quotebegin));
                bspdata[? "map-name"] = string_copy(_ln, _quotebegin + 1, _quoteend - 1);
                break;
            }
        }
        file_text_close(_arenafile);
    }
    else
    {
        show_debug_message("Can't find / read .arena file.. :(");
    }
}
// map textures
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
}

// TODO : Work on texture packing!!
bspdata[? "res-tex-dir"] = _texdirlist;
bspdata[? "res-texatlas-w"] = 2048;
bspdata[? "res-texatlas-h"] = 2048;
bspdata[? "res-texatlas"] = surface_create(bspdata[? "res-texatlas-w"], bspdata[? "res-texatlas-h"]);

// ==================================================================
/// (Finally) Begin loading from BSP file
// ==================================================================
var _filebuffer = buffer_load(_bspfile);
buffer_seek(_filebuffer, buffer_seek_start, 0);

// Header
zbsp_append_log(bspdata, "[HEADER] ===================");
var _magic = zbsp_read_str(_filebuffer, 4); zbsp_append_log(bspdata, "MAGIC STRING : " + _magic);
var _version = buffer_read(_filebuffer, buffer_s32); zbsp_append_log(bspdata, "BSP VERSION : " + string(_version));
if (_magic != "IBSP" || _version != $2e)
{
    /// possibly wrong file type
    zbsp_append_log(bspdata, "INVALID FILE... ABORT");
    
    bspdata[? "success"] = false;
    bspdata[? "error"] = "FILEINVALID";
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
zbsp_load_lump_textures(_filebuffer, bspdata);

// Load plane data
zbsp_load_lump_planes(_filebuffer, bspdata);

// Load node data
zbsp_load_lump_nodes(_filebuffer, bspdata);

// Load leaf data
zbsp_load_lump_leafs(_filebuffer, bspdata);

// (DEBUG) Build wireframe vertex buffer of leaf bounding box
vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_color();
zbspDebugVF = vertex_format_end();
zbspLeafbboxVB = vertex_create_buffer();

vertex_begin(zbspLeafbboxVB, zbspDebugVF);
var _leafs = bspdata[? "leafs-data"];
for (var i=0; i<bspdata[? "leafs-num"]; i++)
{
    var _minx = _leafs[# 2, i], _miny = _leafs[# 3, i], _minz = _leafs[# 4, i];
    var _maxx = _leafs[# 5, i], _maxy = _leafs[# 6, i], _maxz = _leafs[# 7, i];
    
    // side 1
    vertex_position_3d(zbspLeafbboxVB, _minx, _miny, _minz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    vertex_position_3d(zbspLeafbboxVB, _maxx, _miny, _minz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    
    vertex_position_3d(zbspLeafbboxVB, _minx, _miny, _minz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    vertex_position_3d(zbspLeafbboxVB, _minx, _maxy, _minz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    
    vertex_position_3d(zbspLeafbboxVB, _minx, _miny, _minz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    vertex_position_3d(zbspLeafbboxVB, _minx, _miny, _maxz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    
    // side 2
    vertex_position_3d(zbspLeafbboxVB, _maxx, _maxy, _maxz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    vertex_position_3d(zbspLeafbboxVB, _minx, _maxy, _maxz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    
    vertex_position_3d(zbspLeafbboxVB, _maxx, _maxy, _maxz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    vertex_position_3d(zbspLeafbboxVB, _maxx, _miny, _maxz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    
    vertex_position_3d(zbspLeafbboxVB, _maxx, _maxy, _maxz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
    vertex_position_3d(zbspLeafbboxVB, _maxx, _maxy, _minz); vertex_colour(zbspLeafbboxVB, c_lime, 1);
}
vertex_end(zbspLeafbboxVB);
vertex_freeze(zbspLeafbboxVB);

// Free buffer from leaking the memory
buffer_delete(_filebuffer);

zbsp_append_log(bspdata, "ZBSP_LOAD_MAP() END");
return bspdata;
