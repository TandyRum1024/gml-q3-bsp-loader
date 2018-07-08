//
// Simple (NOT) passthrough vertex shader
//
attribute vec3 in_Position;
attribute vec4 in_Colour;
attribute vec3 in_Normal;

//Albedo coordinate
attribute vec2 in_TextureCoord0;
//TextureIndex
attribute vec2 in_TextureCoord1;
//Lightmap coordinate
attribute vec2 in_TextureCoord2;

varying vec2 v_vTexindex;
varying vec2 v_vTexcoord;
varying vec2 v_vLmapcoord;
varying vec4 v_vColour;

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = in_Colour;
    v_vTexcoord = in_TextureCoord0;
    v_vTexindex = in_TextureCoord1;
    v_vLmapcoord = in_TextureCoord2;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~

//
// Simple passthrough fragment shader
//
varying vec2 v_vTexindex;
varying vec2 v_vTexcoord;
varying vec2 v_vLmapcoord;
varying vec4 v_vColour;

// uniform sampler2D vTexture;
uniform sampler2D vLightMap;

void main()
{
    vec4 final;
    
    //Albedo / diffuse or something
    vec4 albedo = vec4(1.0);// texture2D( vTexture, v_vTexcoord );
    //Lightmap
    vec4 lightMap = texture2D( vLightMap, (v_vLmapcoord) );
    
    // That instagram filter shit
    // ( Ambient boost )
    lightMap.a = 1.0;
    lightMap.r += 0.005;
    lightMap.b += 0.010;
    
    //Lightmap
    //2 * Lmap * Diffuse
    // NOTE 2018 : I kinda brightened it up because it was too dark!
    final = 3.5 * albedo * lightMap;
    
    gl_FragColor = final;
}

