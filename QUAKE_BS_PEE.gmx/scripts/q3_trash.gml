/*

NOTE 2018 : This script used to be temporary trashbin for Unused script which might be used later
But as you see, I kinda abandoned the whole thing.
So nothing to see here, Keep goin!

Step event 1, line 106
=============

Now iterate thru FACES for more shit
CULLED = 0;

ds_list_clear(visFACE);
q3_facevisible_clear();
for (var l=0;l<array_height_2d(LEAVES);l++)
{
    //var cLEAF = visLEAF[| l];
    
    var sFACE = LEAVES[@ l, 8];
    var nFACE = LEAVES[@ l, 9];
    
    for (var f=0;f<nFACE;f++)
    {
        var curFACE = f+sFACE;
        if (!q3_facevisible_get(curFACE))
        {
            q3_facevisible_set(curFACE);
            ds_list_add(visFACE, curFACE);
        }
        else
        {
            CULLED++;
        }
    }
}
gLEAF_L.STR = gLEAF_L.STR+"#"+string(CULLED)+" FACES CULLED WITH BITSET";
*/

/*

Draw event 1, Line 43
=============================

    d3d_primitive_begin_texture(pr_trianglelist, surface_get_texture(LMAPS));
        for (var vf=0;vf<ds_list_size(visFACE);vf++)
        {
            f = visFACE[| vf];
            
            lFACE = LFACES[@ f];
            FACETYPE = FACES[# 2, lFACE];
            
            if (FACETYPE == 1 || FACETYPE == 3)
            {
                sMVERT = FACES[# 5, lFACE];
                nMVERT = FACES[# 6, lFACE];
                
                //Start of the vertices
                sVERT = FACES[# 3, lFACE];
                //Lightmap! (offset)
                iLMAP = (FACES[# 7, lFACE])/(numLMAPS);
                
                for (var v=0;v<nMVERT;v++)
                {
                    vCUR = MVERTS[@ sMVERT+v]+sVERT;
                    
                    X = VERTS[# 0, vCUR];
                    Y = VERTS[# 1, vCUR];
                    Z = VERTS[# 2, vCUR];
                    
                    //Lightmap UV (for now)
                    //Calculate the offset!
                    U = (VERTS[# 5, vCUR] / numLMAPS)+iLMAP;
                    V = VERTS[# 6, vCUR];
                    
                    nX = VERTS[# 7, vCUR];
                    nY = VERTS[# 8, vCUR];
                    nZ = VERTS[# 9, vCUR];
                    
                    R = VERTS[# 10, vCUR];
                    G = VERTS[# 11, vCUR];
                    B = VERTS[# 12, vCUR];
                    A = VERTS[# 13, vCUR];
                    
                    d3d_vertex_normal_texture_colour(X, Y, Z, nX, nY, nZ, U, V, c_white, A);
                }
            }
        }
    d3d_primitive_end();
*/
