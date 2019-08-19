///zbsp_fetch_asset_dir(datamap, file)
/*
    Tries to return the path to asset with given relative asset path.
*/

var _mapdir = argument0[? "res-dir"] + "\" + argument1;
var _basedir = "bspdata\res\" + argument1;

if (file_exists(_mapdir))
{
    return _mapdir;
}
else if (file_exists(_basedir))
{
    return _basedir;
}
else
{
    return "";
}
