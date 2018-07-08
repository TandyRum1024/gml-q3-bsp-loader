///q3_load_nodes(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMNODE = LEN / SIZE;
var NODES = 0;

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMNODE;i++)
{
    //Plane
    NODES[ i, 0] = q3_read_int(FILE);
    //Front
    NODES[ i, 1] = q3_read_int(FILE);
    //Back
    NODES[ i, 2] = q3_read_int(FILE);
    //AABB min
    NODES[ i, 4] = q3_read_int(FILE);
    NODES[ i, 3] = q3_read_int(FILE);
    NODES[ i, 5] = q3_read_int(FILE);
    
    //AABB max
    NODES[ i, 7] = q3_read_int(FILE);
    NODES[ i, 6] = q3_read_int(FILE);
    NODES[ i, 8] = q3_read_int(FILE);
    
    //show_debug_message("FRONT "+string(NODES[ i, 1])+" BACK "+string(NODES[ i, 2]));
}

return NODES;
