///zbsp_load_lump_entities(buffer, map)
/*
    Loads entities data from given buffer into the given map
    ==========================================================
    The data can be accessed from the given map with the key "entities", Which referes to a string containing formated entity descriptions.
*/
var _off = argument1[? "entities-diroff"], _len = argument1[? "entities-dirlen"];
buffer_seek(argument0, buffer_seek_start, _off);

argument1[? "entities"] = zbsp_read_str(argument0, _len);
