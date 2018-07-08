///q3_load_lightmap(Buffer, Offset, Length, Size, Combine)
var FILE = argument0;
var OFFSET = argument1;
var LEN = argument2;
var SIZE = argument3;
var COMBINE = argument4;

var numLM = LEN / SIZE;
var LMAPS = 0;

//Iterate 128 * 128 times, filling the surfaces one by one.
var dLM = 128*128*3; //Offset
var R,G,B;
var ROW,POS,OFF;

if (!COMBINE)
{
    for (var i=0;i<numLM;i++)
    {
        LMAPS[i] = surface_create(128, 128);
        surface_set_target(LMAPS[i]);
            draw_clear_alpha(0, 0.6);
        surface_reset_target();
    }

    for (var i=0;i<numLM;i++)
    {
        OFF = i * dLM;
        surface_set_target(LMAPS[@ i]);
        for (var Y=0;Y<128;Y++)
        {
            ROW = Y * (128 * 3);
            for (var X=0;X<128;X++)
            {
                POS = OFFSET + X * 3 + ROW + OFF;
                //RED (one-byte)
                R = buffer_peek(FILE, POS, buffer_u8);
                //GREEN
                G = buffer_peek(FILE, POS+1, buffer_u8);
                //BLUE
                B = buffer_peek(FILE, POS+2, buffer_u8);
                
                //Buffer_set_surface is really broken.
                //So we have to use the sloppy draw_point one.
                draw_point_colour(X, Y, make_colour_rgb(R, G, B));
            }
        }
        surface_reset_target();
    }
}
else
{
    var COMBINED = surface_create( (130)*numLM, 128);
    surface_set_target(COMBINED);
        draw_clear_alpha(c_fuchsia, 1);
    surface_reset_target();
    
    surface_set_target(COMBINED);
    
    for (var i=0;i<numLM;i++)
    {
        OFF = i * dLM;
        for (var Y=0;Y<128;Y++)
        {
            ROW = Y * (128 * 3);
            for (var X=0;X<128;X++)
            {
                POS = OFFSET + X * 3 + ROW + OFF;
                //RED (one-byte)
                R = buffer_peek(FILE, POS, buffer_u8);
                //GREEN
                G = buffer_peek(FILE, POS+1, buffer_u8);
                //BLUE
                B = buffer_peek(FILE, POS+2, buffer_u8);
                
                //Buffer_set_surface is really broken.
                //So we have to use the sloppy draw_point one.
                draw_point_colour(X+i*(130), Y, make_colour_rgb(R, G, B));
                /*Padding*/
                //Left
                if (X == 0)
                {
                    draw_point_colour(X+i*(130)-1, Y, make_colour_rgb(R, G, B));
                }
                //Right
                if (X == 127)
                {
                    draw_point_colour(X+i*(130)+1, Y, make_colour_rgb(R, G, B));
                }
            }
        }
    }
    surface_reset_target();
    
    LMAPS = COMBINED;
}

return LMAPS;
