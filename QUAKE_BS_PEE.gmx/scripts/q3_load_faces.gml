///q3_load_faces(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMFACE = LEN / SIZE;
var FACES = ds_grid_create(13, NUMFACE);

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMFACE;i++)
{
    //Texture index
    FACES[# 0, i] = q3_read_int(FILE);
    //Effect index
    FACES[# 1, i] = q3_read_int(FILE);
    //Face type
    FACES[# 2, i] = q3_read_int(FILE);
    //First Vertex index
    FACES[# 3, i] = q3_read_int(FILE);
    //Numbers of vertex
    FACES[# 4, i] = q3_read_int(FILE);
    //First meshVert index
    FACES[# 5, i] = q3_read_int(FILE);
    //Numbers of meshVert
    FACES[# 6, i] = q3_read_int(FILE);
    //Lightmap index
    FACES[# 7, i] = q3_read_int(FILE);
    //(SKIPPED) Lm_start
    q3_read_int(FILE);q3_read_int(FILE);
    //(SKIPPED) Lm_size
    q3_read_int(FILE);q3_read_int(FILE);
    //(SKIPPED) Lm_origin
    q3_read_float(FILE);q3_read_float(FILE);q3_read_float(FILE);
    //(SKIPPED) Lm_vecs
    q3_read_float(FILE);
    q3_read_float(FILE);
    q3_read_float(FILE);
    q3_read_float(FILE);
    q3_read_float(FILE);
    q3_read_float(FILE);
    //normalSurface
    FACES[# 9, i] = q3_read_float(FILE);
    FACES[# 8, i] = q3_read_float(FILE);
    FACES[# 10, i] = q3_read_float(FILE);
    
    //Bezier patch dimensions
    FACES[# 11, i] = q3_read_int(FILE);
    FACES[# 12, i] = q3_read_int(FILE);
}

return FACES;
