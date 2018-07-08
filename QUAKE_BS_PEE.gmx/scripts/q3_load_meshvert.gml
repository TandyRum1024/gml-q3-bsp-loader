///q3_load_meshvert(Buffer, offset, length, size)
var FILE = argument0;
var OFF = argument1;
var LEN = argument2;
var SIZE = argument3;

var NUMMVERT = LEN / SIZE;
var MVERTS = 0;

buffer_seek(FILE, buffer_seek_start, OFF);
for (var i=0;i<NUMMVERT;i++)
{
    MVERTS[i] = q3_read_int(FILE);
}

return MVERTS;
