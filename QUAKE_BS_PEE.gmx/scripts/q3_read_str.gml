///q3_read_str(Buffer, characters)
var BUFFER = argument0;
var STR = "";

for (var i=0;i<argument1;i++)
{
    STR += ansi_char(buffer_read(BUFFER, buffer_u8));
}

return STR;
