///vui_draw_gui(GUI)
//var GUI = guiELEMENT;

var GUID = argument0;//GUI[# 0,argument0];
var STYLE = GUID.STYLE;

var X = GUID.x;
var Y = GUID.y;
var W = GUID.W;
var H = GUID.H;

/* DRAW BASE PANEL */

if (STYLE == 0) //NADA
{
    //DUH
}
else if (STYLE == 1) //COLOUR
{
    var C = GUID.COL;
    draw_rectangle_colour(X, Y, X+GUID.W, Y+GUID.H, C, C, C, C, false);
}
else if (STYLE == 2) //TILED (NOT DONE, SORRY ;-;)
{
    draw_sprite_stretched(sGUI_TILE, 0, X, Y, GUID.W, GUID.H);
}
else if (STYLE == 3) //DOS
{
    var C = GUID.COL;
    
    draw_rectangle_colour(X, Y, X+W, Y+H, C, C, C, C, false);
    
    draw_line_width_colour(X+6, Y+6, X+W-6, Y+6, 4, c_ltgray, c_ltgray);
    draw_line_width_colour(X+W-8, Y+6, X+W-8, Y+H-6, 4, c_ltgray, c_ltgray);
    draw_line_width_colour(X+6, Y+H-6, X+W-6, Y+H-6, 4, c_ltgray, c_ltgray);
    draw_line_width_colour(X+8, Y+H-6, X+8, Y+6, 4, c_ltgray, c_ltgray);
}
else if (STYLE == 4) //Stupid style
{
    var C = GUID.COL;
    
    draw_rectangle_colour(X, Y, X+W, Y+H, C, C, C, C, false);
    draw_rectangle_colour(X, Y, X+W, Y+30, cRED, cRED, cRED, cRED, false);
}

/* DRAW TITLE */
var TITLE = GUID.TITLE;
draw_text_transformed_colour(X+4, Y, TITLE, 0.5, 0.75, 0, cMINT, cMINT, cMINT, cMINT, 1);

/* DRAW LIST */
var ITEMS = GUID.ITEMS;
var CURRENT,TYPE;

var IX, IY, IW, IH;
for (var i=0;i<ds_list_size(ITEMS);i++)
{
    CURRENT = ITEMS[| i];
    TYPE = CURRENT.TYPE;
    
    //-=TODO : DRAW SHIT=-
    IX = CURRENT.x;
    IY = CURRENT.y;
    IW = CURRENT.W;
    IH = CURRENT.H;
    
    if (TYPE == uiTYPE.PANEL)
    {
        var ICOL = CURRENT.COL;
        
        draw_rectangle_colour(IX, IY, IX+IW, IY+IH, ICOL, ICOL, ICOL, ICOL, false);
    }
    else if (TYPE == uiTYPE.LABEL)
    {
        var STR = CURRENT.STR;
        var ICOL = CURRENT.COL;
        
        draw_text_transformed_colour(IX, IY, STR, IW, IH, 0 , ICOL, ICOL, ICOL, ICOL, 1.0);
    }
    else if (TYPE == uiTYPE.BUTTON)
    {
        var STR = CURRENT.STR;
        var INDEX = CURRENT.BTNIND;
        
        var BCOL = CURRENT.B_COL;
        var TCOL = CURRENT.T_COL;
        
        draw_sprite_stretched_ext(sButton, INDEX, IX, IY, IW, IH, BCOL, 1.0);
        
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
            draw_text_transformed_colour(IX+IW/2, IY+IH/2, STR, 0.6, 0.6, 0, TCOL, TCOL, TCOL, TCOL, 1.0);
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
    }
    else if (TYPE == uiTYPE.texPANEL)
    {
        var TEX = CURRENT.TEX;
        
        draw_primitive_begin_texture(pr_trianglestrip, TEX);
            draw_vertex_texture(IX, IY, 0, 0);
            draw_vertex_texture(IX + IW, IY, 1, 0);
            draw_vertex_texture(IX, IY + IH, 0, 1);
            draw_vertex_texture(IX + IW, IY + IH, 1, 1);
        draw_primitive_end();
    }
}
