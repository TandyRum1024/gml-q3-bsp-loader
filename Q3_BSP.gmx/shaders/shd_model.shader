//
// Model shader (with lightvolume info)
//
attribute vec3 in_Position;                  // (x,y,z)
attribute vec3 in_Normal;                    // (x,y,z)
attribute vec4 in_Colour;                    // (r,g,b,a)
attribute vec2 in_TextureCoord;              // (u,v)

varying vec2 v_vTexcoord;
varying vec3 v_vNormal;
varying vec4 v_vColour;

// lightvolume info
uniform vec3 uLightAmbient; // ambient colour
uniform vec3 uLightDirectional; // directional colour
uniform vec2 uLightPhiTheta; // spherical coords (x = phi, y = theta)

void main()
{
    vec4 object_space_pos = vec4( in_Position.x, in_Position.y, in_Position.z, 1.0);
    gl_Position = gm_Matrices[MATRIX_WORLD_VIEW_PROJECTION] * object_space_pos;
    
    v_vColour = vec4(uLightAmbient, 1.0);
    v_vTexcoord = in_TextureCoord;
    v_vNormal = in_Normal;
}

//######################_==_YOYO_SHADER_MARKER_==_######################@~//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec3 v_vNormal;
varying vec4 v_vColour;

void main()
{
    gl_FragColor = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
}

