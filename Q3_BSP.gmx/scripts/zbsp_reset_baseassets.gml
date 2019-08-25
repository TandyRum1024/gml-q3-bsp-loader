///zbsp_reset_baseassets(pk3)
/*
    Cleans internal base assets folder & re-generates base assets from given pk3 file.
*/
var _asset = argument0;
var _datafolder = "bspdata";
var _assetfolder = _datafolder + "\res";

if (_asset == -1)
{
    // PURGE
    directory_destroy(_assetfolder);
}
else 
{
    if (file_exists(_asset))
    {
        // unzip & check if we successfully unzipped the base assets
        return zip_unzip(_asset, _assetfolder);
    }
    else
    {
        show_debug_message("Asset directory not exists.. (" + _asset + ")");
        return false;
    }
}
