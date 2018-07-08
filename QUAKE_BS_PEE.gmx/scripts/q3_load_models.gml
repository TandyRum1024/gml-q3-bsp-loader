///q3_load_models(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMMODEL = LEN / SIZE;

var MODELS = 0;

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMMODEL;i++)
{
    //Minimum AABB
    MODELS[ i, 0] = q3_read_float(FILE);
    MODELS[ i, 1] = q3_read_float(FILE);
    MODELS[ i, 2] = q3_read_float(FILE);
    //Maximum AABB
    MODELS[ i, 3] = q3_read_float(FILE);
    MODELS[ i, 4] = q3_read_float(FILE);
    MODELS[ i, 5] = q3_read_float(FILE);
    //First face
    MODELS[ i, 6] = q3_read_int(FILE);
    //Numbers of faces
    MODELS[ i, 7] = q3_read_int(FILE);
    //First brush(Not really used)
    MODELS[ i, 8] = q3_read_int(FILE);
    //Numbers of brushes
    MODELS[ i, 9] = q3_read_int(FILE);
}

return MODELS;
