///zbsp_load_lump_directory(buffer, map)
/*
    Loads lump's directory (offset & length) from given file buffer into the given map
*/

buffer_seek(argument0, buffer_seek_start, 8);

// load each lumps directory entries
for (var i=0; i<array_length_1d(global.BSPLumpNames); i++)
{
    argument1[? global.BSPLumpNames[@i] + "-diroff"] = buffer_read(argument0, buffer_u32);
    argument1[? global.BSPLumpNames[@i] + "-dirlen"] = buffer_read(argument0, buffer_u32);
}
