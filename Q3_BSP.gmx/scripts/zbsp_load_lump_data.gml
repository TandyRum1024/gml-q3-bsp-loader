///zbsp_load_lump_directory(buffer, map)
/*
    Loads lump's directory (offset & length) from given file buffer
    into the given map
*/

// entities lump
argument1[? "entities-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "entities-dirlen"] = buffer_read(argument0, buffer_u32);

// textures lump
argument1[? "textures-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "textures-dirlen"] = buffer_read(argument0, buffer_u32);

// planes lump
argument1[? "planes-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "planes-dirlen"] = buffer_read(argument0, buffer_u32);

// nodes lump
argument1[? "nodes-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "nodes-dirlen"] = buffer_read(argument0, buffer_u32);

// leafs lump
argument1[? "leafs-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "leafs-dirlen"] = buffer_read(argument0, buffer_u32);

// leaffaces lump
argument1[? "leaffaces-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "leaffaces-dirlen"] = buffer_read(argument0, buffer_u32);

// leafbrushes lump
argument1[? "leafbrushes-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "leafbrushes-dirlen"] = buffer_read(argument0, buffer_u32);

// models lump
argument1[? "models-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "models-dirlen"] = buffer_read(argument0, buffer_u32);

// brushes lump
argument1[? "brushes-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "brushes-dirlen"] = buffer_read(argument0, buffer_u32);

// brushsides lump
argument1[? "brushsides-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "brushsides-dirlen"] = buffer_read(argument0, buffer_u32);

// vertices lump
argument1[? "vertices-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "vertices-dirlen"] = buffer_read(argument0, buffer_u32);

// meshverts lump
argument1[? "meshverts-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "meshverts-dirlen"] = buffer_read(argument0, buffer_u32);

// effects lump
argument1[? "effects-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "effects-dirlen"] = buffer_read(argument0, buffer_u32);

// faces lump
argument1[? "faces-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "faces-dirlen"] = buffer_read(argument0, buffer_u32);

// lightmaps lump
argument1[? "lightmaps-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "lightmaps-dirlen"] = buffer_read(argument0, buffer_u32);

// lightvols lump
argument1[? "lightvols-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "lightvols-dirlen"] = buffer_read(argument0, buffer_u32);

// visdata lump
argument1[? "visdata-diroff"] = buffer_read(argument0, buffer_u32);
argument1[? "visdata-dirlen"] = buffer_read(argument0, buffer_u32);