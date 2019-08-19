///zbsp_atlas_add_sprite(spr)
/*
    Adds sprite to atlas
*/

if (sprite_exists(argument0))
{
    var _arr = array_create(6);
    var _wid = sprite_get_width(argument0);
    var _hei = sprite_get_height(argument0);
    
    _arr[@ 0] = argument0;
    _arr[@ 1] = 0;
    _arr[@ 2] = 0;
    _arr[@ 3] = 0;
    _arr[@ 4] = _wid;
    _arr[@ 5] = _hei;
    
    ds_list_add(zbspAtlasRectList, _arr);
    return _arr;
}
else
{
    return -1;
}
