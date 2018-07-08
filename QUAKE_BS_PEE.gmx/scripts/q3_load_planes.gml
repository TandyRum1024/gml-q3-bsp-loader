///q3_load_planes(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMPLANE = LEN / SIZE;
var PLANES = 0;

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMPLANE;i++)
{
    //Normal
    PLANES[ i, 1] = q3_read_float(FILE);
    PLANES[ i, 0] = q3_read_float(FILE);
    PLANES[ i, 2] = q3_read_float(FILE);
    //Dist
    PLANES[ i, 3] = q3_read_float(FILE);
}

return PLANES;
