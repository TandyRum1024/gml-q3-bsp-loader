///q3_load_leaffaces(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMLFACE = LEN / SIZE;
var LFACES = 0;

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMLFACE;i++)
{
    //Cluster ind
    LFACES[i] = q3_read_int(FILE);
}

return LFACES;
