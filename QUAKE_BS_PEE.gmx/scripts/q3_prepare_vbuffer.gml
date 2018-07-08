///q3_prepare_vbuffer(Leaves, Faces, LeafFaces, Vertexes, MeshVertexes, vbolist, lightmapCount)
var LEAVES = argument0;
var FACES = argument1;
var lFACES = argument2;
var VERTS = argument3;
var MVERTS = argument4;
var vbLIST = argument5;
var numLMAP = argument6;

var sFACE, nFACE, SIZE = 0;

for (var l=0;l<array_height_2d(LEAVES);l++)
{
    sFACE = LEAVES[@ l, 8];
    nFACE = LEAVES[@ l, 9];
    var VBUFF = vbLIST[| l];
    SIZE = 0;
    
    //show_debug_message(string(nFACE)+" Faces starting from Face #"+string(sFACE));
    
    /*Iterate through faces, build the Vertex buffer.*/
    vertex_begin(VBUFF, q3VERT);
        for (var i=sFACE;i<sFACE+nFACE;i++)
        {
            var f = lFACES[@ i];
            var FACETYPE = FACES[# 2, f];
            
            if (FACETYPE == 1 || FACETYPE == 3)
            {
                //Iterate vertices
                var sMVERT = FACES[# 5, f];
                var nMVERT = FACES[# 6, f];
                
                var sVERT = FACES[# 3, f];
                
                var SIZE = (numLMAP * (130));
                var lMAP = ((FACES[# 7, f]) / numLMAP);
                
                for (var v=sMVERT; v<sMVERT+nMVERT; v++)
                {
                    var VT = MVERTS[@ v]+sVERT;
                    
                    var X = VERTS[# 0, VT];
                    var Y = VERTS[# 1, VT];
                    var Z = VERTS[# 2, VT];
                    
                    var U = VERTS[# 3, VT];
                    var V = VERTS[# 4, VT];
                    //Lightmap
                    var lU = (VERTS[# 5, VT]) / (numLMAP) + lMAP;
                    var lV = VERTS[# 6, VT];//+(0.5/128);
                    
                    var nX = VERTS[# 7, VT];
                    var nY = VERTS[# 8, VT];
                    var nZ = VERTS[# 9, VT];
                    
                    var R = VERTS[# 10, VT];
                    var G = VERTS[# 11, VT];
                    var B = VERTS[# 12, VT];
                    var A = VERTS[# 13, VT];
                    
                    //Texture indices
                    vertex_position_3d(VBUFF, X, Y, Z);
                    vertex_colour(VBUFF, make_colour_rgb(R, G, B), A);
                    vertex_normal(VBUFF, nX, nY, nZ);
                    vertex_texcoord(VBUFF, U, V);
                    vertex_float2(VBUFF, FACES[# 0, f], FACES[# 7, f]);
                    vertex_texcoord(VBUFF, lU, lV);
                    SIZE++;
                    //show_debug_message("BONK");
                }
            }
            else if (FACETYPE == 2)
            {
                    
            }
        }
    
    vertex_end(VBUFF);
    
    // NOTE 2018 : I noticed that printing debug messages made the whole progress kinda slower.
    // Uncomment those show_debug_message(s) to get those delicious debug messages!
    
    //Maybe throw it into the freezer for longer shelf life.
    // show_debug_message("Leaf is done with size of "+string(vertex_get_buffer_size(VBUFF)));
    if (SIZE > 0)
    {
        vertex_freeze(VBUFF);
        // show_debug_message("Froze buffer #"+string(l))
    }
}
