///zbsp_load_map(filename)
/*
    Loads Quake 3 map from zip/pk3 file, And returns ds_map containing the map information.
*/

/// define variables
var bspdata = ds_map_create(); // map containing the bsp data
var _filetype = filename_ext(argument0);
var _filename = string_copy(filename_name(argument0), 0, string_pos(".", argument0) - 1);

// setup values
bspdata[# "success"] = true;
bspdata[# "error"] = "";
bspdata[# "debug_log"] = "BEGIN LOADING FILE : [" + string(argument0) + "]#===#";

if (!file_exists(argument0))
{
    /// file doesn't exist : bail out
    bspdata[# "success"] = false;
    bspdata[# "error"] = "NOFILE";
}
else
{
    /// unpack zip/pk3 file before processing
    zbsp_append_log(bspdata, "UNPACKING...");
}
return bspdata;
