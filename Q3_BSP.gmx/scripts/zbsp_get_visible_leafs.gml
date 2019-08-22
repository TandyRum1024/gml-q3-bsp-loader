///zbsp_get_visible_leafs(bspdata, list, cluster)
/*
    Stores all of the visible leaf index from given visible cluster into the given list.
    (The list will be cleared first)
*/

var bspdata = argument0;
var _list = argument1, _cluster = argument2;

ds_list_clear(_list);
var _culled = 0;

if (bspdata[? "visdata-num"] <= 0 || bspdata[? "visdata-size"] <= 0 || _cluster < 0)
{
    for (var i=0; i<bspdata[? "leafs-num"]; i++)
    {
        ds_list_add(_list, i);
    }
}
else
{
    var _leafs = bspdata[? "leafs-data"];
    var _visdata = bspdata[? "visdata"];
    var _bytespercluster = bspdata[? "visdata-size"];

    for (var i=0; i<bspdata[? "leafs-num"]; i++)
    {
        var _clustervictm = _leafs[# eBSP_LEAF.VISCLUSTER, i];
        
        // Check PVS bits
        // each cluster has _bytespercluster amount of list entries, with each bit corresponding to other clusters.
        var _vecidx = (_cluster * _bytespercluster) + (_clustervictm >> 3);
        var _bitset = buffer_peek(_visdata, _vecidx, buffer_u8);
        if (_bitset & (1 << (_clustervictm & 7)) != 0)
        {
            ds_list_add(_list, i);
        }
        else
        {
            _culled++;
        }
    }
}

return _culled;
