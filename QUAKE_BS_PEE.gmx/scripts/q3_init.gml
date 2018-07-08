//Init the quake3 map vertex thing

vertex_format_begin();
    vertex_format_add_position_3d();
    vertex_format_add_colour();
    vertex_format_add_normal();
    vertex_format_add_textcoord();
    
    //custom thing
    //texture(s) index, for atlas shit later on
    //Use it something like vTexCoord2
    // NOTE 2018 : Sorry for curse words, 2017 me was hella trash :/
    // Anyway, We define the custom vertex format to shove into the shader
    // for lightmap / texture index.
    vertex_format_add_custom( vertex_type_float2, vertex_usage_textcoord);
    
    //Lightmap
    vertex_format_add_textcoord();
q3VERT = vertex_format_end();

