///zbsp_check_visible(bspdata, cluster, checkcluster)
/*
    Checks checkcluster is visible from given cluster.
    (Uses PVS data from bsp data map)
*/

var bspdata = argument0;
var _cluster = argument1, _checkcluster = argument2;

if (bspdata[? "visdata-num"] <= 0 || bspdata[? "visdata-size"] <= 0 || _cluster < 0)
{
    return true;
}
else
{
    var _visdata = bspdata[? "visdata"];
    var _bytespercluster = bspdata[? "visdata-size"];
    
    // Check PVS bits
    // each cluster has _bytespercluster amount of list entries, with each bit corresponding to other clusters.
    var _vecidx = _cluster * _bytespercluster + (_checkcluster >> 3);
    
    if (buffer_peek(_visdata, _vecidx, buffer_u8) & (1 << (_checkcluster & 7)))
    {
        return true;
    }
}
