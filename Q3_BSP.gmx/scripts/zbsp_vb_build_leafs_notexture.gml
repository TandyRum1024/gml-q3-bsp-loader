///zbsp_vb_build_leafs_notexture(mapdata)
/*
    Builds vertex buffer for every leafs and stores it inside of the given bsp data ds_map.
    The list of buffers can be accessed from the given ds_map level data with key "vb-leafs",
    And it's vertex format with "vb-format-face-notex".
    
    Only contains lightmap UVs information, Using following format :
    vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_colour();
    vertex_format_add_textcoord(); // Lightmap UV, Refered as "in_TextureCoord" in shader
    vertex_format_add_normal();
*/

var bspdata = argument0;

vertex_format_begin();
vertex_format_add_position_3d();
vertex_format_add_colour();
vertex_format_add_textcoord();
vertex_format_add_normal();
var _debugVF = vertex_format_end();

// Vertex offset lookup table for indexing & weaving a bezier patch
var _patchidxlut = -1;
_patchidxlut[0, 0] = 0; _patchidxlut[0, 1] = 0;
_patchidxlut[1, 0] = 0; _patchidxlut[1, 1] = 1;
_patchidxlut[2, 0] = 1; _patchidxlut[2, 1] = 0;
_patchidxlut[3, 0] = 1; _patchidxlut[3, 1] = 0;
_patchidxlut[4, 0] = 0; _patchidxlut[4, 1] = 1;
_patchidxlut[5, 0] = 1; _patchidxlut[5, 1] = 1;

// Lightmap default uv
var _lmapdefaultu = texture_get_texel_width(bspdata[? "res-lightatlas-tex"]);
var _lmapdefaultv = texture_get_texel_height(bspdata[? "res-lightatlas-tex"]);

// Various level data
var _leafs = bspdata[? "leafs-data"];
var _leaffaces = bspdata[? "leaffaces-data"];
var _faces = bspdata[? "faces-data"];
var _vertices = bspdata[? "vertices-data"];
var _meshverts = bspdata[? "meshverts-data"];
var _lmapinfo = bspdata[? "lightmaps-data"];

bspdata[? "vb-leafs"] = ds_list_create();

for (var i=0; i<bspdata[? "leafs-num"]; i++)
{
    // Fetch first leafface index & number
    var _lfidx = _leafs[# eBSP_LEAF.LEAFFACE_IDX, i], _lfnum = _leafs[# eBSP_LEAF.LEAFFACE_NUM, i];
    
    // Create a vertexbuffer for leaf
    var _debugVB = vertex_create_buffer();
    vertex_begin(_debugVB, _debugVF);
    var _vertctr = 0;    
    var _vertexcol = c_white;
    
    for (var l=0; l<_lfnum; l++)
    {
        var _faceidx = _leaffaces[| _lfidx + l];
    
        // Fetch face type
        var _type = _faces[# eBSP_FACE.TYPE, _faceidx];
        
        // Fetch first meshverts idx and number
        var _meshvertidx = _faces[# eBSP_FACE.MESHVERT_IDX, _faceidx], _meshvertnum = _faces[# eBSP_FACE.MESHVERT_NUM, _faceidx];
        
        // Fetch first vertex idx and number
        var _vertidx = _faces[# eBSP_FACE.VERTEX_IDX, _faceidx], _vertnum = _faces[# eBSP_FACE.VERTEX_NUM, _faceidx];
        
        // Fetch texture & lightmap index
        var _texidx = _faces[# eBSP_FACE.TEXTURE, _faceidx];
        var _lmapidx = _faces[# eBSP_FACE.LIGHTMAP, _faceidx];
        var _lmapu, _lmapv, _lmapusz, _lmapvsz;
        
        if (_lmapidx < 0)
        {
            // Not using lightmap? use default notexture uv instead..
            _lmapu = _lmapdefaultu;
            _lmapv = _lmapdefaultv;
            _lmapusz = _lmapdefaultu;
            _lmapvsz = _lmapdefaultv;
        }
        else
        {
            // UV starting coords
            _lmapu = _lmapinfo[# eBSP_LIGHTMAP.UV_MIN_X, _lmapidx];
            _lmapv = _lmapinfo[# eBSP_LIGHTMAP.UV_MIN_Y, _lmapidx];
            
            // UV size
            _lmapusz = _lmapinfo[# eBSP_LIGHTMAP.UV_MAX_X, _lmapidx] - _lmapu;
            _lmapvsz = _lmapinfo[# eBSP_LIGHTMAP.UV_MAX_Y, _lmapidx] - _lmapv;
        }
        
        /// Type dependant vertex building code
        switch (_type)
        {
            case eBSP_FACE_TYPE.MESH: // Mesh
            case eBSP_FACE_TYPE.POLYGON: // Polygon (Thankfully they've already triangulated the polygons)
                for (var j=0; j<_meshvertnum; j++)
                {
                    // Calculate current vertex index from meshvert offset & first vertex index
                    var _cvertex = _vertidx + _meshverts[| _meshvertidx + j];
                    
                    // Append vertex to buffer
                    vertex_position_3d(_debugVB, _vertices[# eBSP_VERTEX.X, _cvertex], _vertices[# eBSP_VERTEX.Y, _cvertex], _vertices[# eBSP_VERTEX.Z, _cvertex]);
                    
                    //vertex_colour(_debugVB, _vertices[# eBSP_VERTEX.COLOUR, _cvertex], _vertices[# eBSP_VERTEX.ALPHA, _cvertex]);
                    vertex_colour(_debugVB, _vertexcol, 1);
                    
                    vertex_texcoord(_debugVB, _lmapu + _lmapusz * _vertices[# eBSP_VERTEX.LMAP_U, _cvertex], _lmapv + _lmapvsz * _vertices[# eBSP_VERTEX.LMAP_V, _cvertex]);
                    
                    vertex_normal(_debugVB, _vertices[# eBSP_VERTEX.NORMAL_X, _cvertex], _vertices[# eBSP_VERTEX.NORMAL_Y, _cvertex], _vertices[# eBSP_VERTEX.NORMAL_Z, _cvertex]);
                    
                    _vertctr++;
                }
                break;
            
            case eBSP_FACE_TYPE.BILLBOARD: // Billboard
                
            case eBSP_FACE_TYPE.BEZIERPATCH: // Bezier patch (Draw control points for now)
                // Fetch control points grid dimensions
                var _bezierw = _faces[# eBSP_FACE.BEZIERPATCH_W, _faceidx], _bezierh = _faces[# eBSP_FACE.BEZIERPATCH_H, _faceidx];
                
                // Read control points
                for (var j=0; j<_bezierw - 1; j++)
                {
                    for (var k=0; k<_bezierh - 1; k++)
                    {
                        // Get control points for patch
                        for (var o=0; o<6; o++)
                        {
                            // Calculate current vertex index
                            var _x = j + _patchidxlut[o, 0];
                            var _y = k + _patchidxlut[o, 1];
                            var _cvertex = _vertidx + (_x + _y * _bezierw);
                            
                            // "percentage" values that goes from 0 to 1
                            var _widlerp = _x / (_bezierw - 1);
                            var _heilerp = _y / (_bezierh - 1);
                            var _col = make_color_rgb(_widlerp * 255, _heilerp * 255, 128);
                            
                            vertex_position_3d(_debugVB, _vertices[# eBSP_VERTEX.X, _cvertex], _vertices[# eBSP_VERTEX.Y, _cvertex], _vertices[# eBSP_VERTEX.Z, _cvertex]);
                            
                            // vertex_colour(_debugVB, _vertices[# eBSP_VERTEX.COLOUR, _cvertex], _vertices[# eBSP_VERTEX.ALPHA, _cvertex]);
                            vertex_colour(_debugVB, _col, 1); // debug rainbow clown vomit colour
                            
                            vertex_texcoord(_debugVB, _lmapu + _lmapusz * _vertices[# eBSP_VERTEX.LMAP_U, _cvertex], _lmapv + _lmapvsz * _vertices[# eBSP_VERTEX.LMAP_V, _cvertex]);
                            
                            vertex_normal(_debugVB, _vertices[# eBSP_VERTEX.NORMAL_X, _cvertex], _vertices[# eBSP_VERTEX.NORMAL_Y, _cvertex], _vertices[# eBSP_VERTEX.NORMAL_Z, _cvertex]);
                            
                            _vertctr++;
                        }
                    }
                }
                break;
        }
    }
    
    // Tidy up stuff & into the buffer list it goes
    vertex_end(_debugVB);
    if (_vertctr >= 1)
    {
        vertex_freeze(_debugVB);
    }
    
    ds_list_add(bspdata[? "vb-leafs"], _debugVB);
}

bspdata[? "vb-format-face-notex"] = _debugVF;
