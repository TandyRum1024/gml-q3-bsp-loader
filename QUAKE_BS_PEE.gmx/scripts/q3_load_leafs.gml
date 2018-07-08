///q3_load_leafs(Buffer, offset, length, size, vbolist)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;
var vbLIST = argument4;

var NUMLEAF = LEN / SIZE;
var LEAFS = 0;

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMLEAF;i++)
{
    //Cluster ind
    LEAFS[ i, 0] = q3_read_int(FILE);
    //Area portal
    LEAFS[ i, 1] = q3_read_int(FILE);
    //minimum AABB
    //X and Y swap for fixing Coords.
    LEAFS[ i, 3] = q3_read_int(FILE);
    LEAFS[ i, 2] = q3_read_int(FILE);
    LEAFS[ i, 4] = q3_read_int(FILE);
    //maximum AABB
    //X and Y swap for fixing Coords.
    LEAFS[ i, 6] = q3_read_int(FILE);
    LEAFS[ i, 5] = q3_read_int(FILE);
    LEAFS[ i, 7] = q3_read_int(FILE);
    //Leafface index
    LEAFS[ i, 8] = q3_read_int(FILE);
    //Leafface Numbers
    LEAFS[ i, 9] = q3_read_int(FILE);
    //Leafbrush index
    LEAFS[ i, 10] = q3_read_int(FILE);
    //Leafbrush Numbers
    LEAFS[ i, 11] = q3_read_int(FILE);
    
    //Is visible?
    LEAFS[ i, 12] = false;
    
    //Add vertex buffer thing
    vbLIST[| i] = vertex_create_buffer();
}

return LEAFS;
