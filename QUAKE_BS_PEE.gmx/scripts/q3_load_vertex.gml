///q3_load_vertex(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMVERT = LEN / SIZE;

var VERTICES = ds_grid_create(14,NUMVERT);

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMVERT;i++)
{
    //Pos
    //X and Y swapped for fixing coordinates
    VERTICES[# 1, i] = q3_read_float(FILE);
    VERTICES[# 0, i] = q3_read_float(FILE);
    VERTICES[# 2, i] = q3_read_float(FILE);
    
    //TexCoord
    VERTICES[# 3, i] = q3_read_float(FILE);
    VERTICES[# 4, i] = 1 - q3_read_float(FILE);
    //Lightmap Coord
    //Flipped UV because (0,0) is bottom left in OPENGL.
    VERTICES[# 5, i] = q3_read_float(FILE);
    VERTICES[# 6, i] = 1 - q3_read_float(FILE);
    
    //Normal
    VERTICES[# 8, i] = q3_read_float(FILE);
    VERTICES[# 7, i] = q3_read_float(FILE);
    VERTICES[# 9, i] = q3_read_float(FILE);
    //RGBA col
    VERTICES[# 10, i] = buffer_read(FILE, buffer_u8);
    VERTICES[# 11, i] = buffer_read(FILE, buffer_u8);
    VERTICES[# 12, i] = buffer_read(FILE, buffer_u8);
    VERTICES[# 13, i] = buffer_read(FILE, buffer_u8)/255;
}

return VERTICES;
