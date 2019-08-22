///zbsp_get_leaf_idx(bspdata, x, y, z)
/*
    Walks along the BSP tree from given bsp map data & fetchs leaf index of given position.
*/
var bspdata = argument0;
var _cullX = argument1, _cullY = argument2, _cullZ = argument3;

// data variable
var _leafs = bspdata[? "leafs-data"];
var _nodes = bspdata[? "nodes-data"];
var _planes = bspdata[? "planes-data"];

/// Get current leaf that our camera is in
// Node 0 is the root node of BSP
var _currentnode = 0;

// Walk along
while (_currentnode >= 0)
{
    // Fetch current node's BSP plane & it's attributes
    var _nodeplane = _nodes[# eBSP_NODE.PLANE, _currentnode];
    var _planenx = _planes[# eBSP_PLANE.NORMAL_X, _nodeplane], _planeny = _planes[# eBSP_PLANE.NORMAL_Y, _nodeplane], _planenz = _planes[# eBSP_PLANE.NORMAL_Z, _nodeplane];
    var _planedist = _planes[# eBSP_PLANE.DISTANCE, _nodeplane];
    
    // And use that information to determine whether if we're in front or back of BSP plane
    var _dist = dot_product_3d(_planenx, -_planeny, _planenz, _cullX, _cullY, _cullZ) - _planedist;
    
    // Then walk along nodes
    if (_dist >= 0)
    {
        _currentnode = _nodes[# eBSP_NODE.CHILD_FRONT, _currentnode];
    }
    else
    {
        _currentnode = _nodes[# eBSP_NODE.CHILD_BACK, _currentnode];
    }
}

// If the node children index is negative, Then use that value to get the leaf node's index.
return -_currentnode - 1;
