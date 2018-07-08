///vui_sort_depth(whatever.)
/*
    A insertion sort for GUI.
    For sorting and updating the depth at same time.
    (We don't want to loop twice!)
*/

/*
 Ahh crap, We can't do shit while grid is sorting!
 Why not make our onw thing from scratch?
 So, Here it is.
*/
var SIZE = ds_grid_height(guiELEMENT);
var ECH,TIS,INST;

for (var i=0;i<SIZE;i++)
{
    if (i > 0)
    {
        ECH = guiELEMENT[# 1, i];
        TIS = guiELEMENT[# 0, i];
        
        j = i - 1;
        while (j >= 0 && guiELEMENT[# 1, j] < ECH)
        {
            //SWAP?
            guiELEMENT[# 1, j+1] = guiELEMENT[# 1, j];
            guiELEMENT[# 0, j+1] = guiELEMENT[# 0, j];
            INST = guiELEMENT[# 0, j+1];
            INST.depth = guiELEMENT[# 1, j+1];
            
            j--;
        }
        
        guiELEMENT[# 1, j+1] = ECH;
        guiELEMENT[# 0, j+1] = TIS;
        TIS.depth = ECH;
    }
    //Update the new depth value
    //INST = guiELEMENT[# 0, i];
    //INST.depth = guiELEMENT[# 1, i];
}
