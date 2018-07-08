///vui_draw_gui(GUI)
//var GUI = guiELEMENT;

var GUID = argument0;//GUI[# 0,argument0];
var STYLE = GUID.STYLE;

var X = GUID.x;
var Y = GUID.y;
var W = GUID.W;
var H = GUID.H;

/* DRAW BASE PANEL */
if (STYLE == 0) //CYKABLYAT
{
    //var C = GUID.COL;
   
    //Backdrop
    draw_rectangle_colour(X, Y, X+W, Y+H, KOK.ASH, KOK.ASH, KOK.ASH, KOK.ASH, false);
    draw_rectangle_colour(X, Y+H, X+W, Y+H+5, KOK.WINEBLACK, KOK.WINEBLACK, KOK.WINEBLACK, KOK.WINEBLACK, false);
    
    //TopKEK
    draw_rectangle_colour(X, Y+20, X+W, Y+25, KOK.WINEBLACK, KOK.WINEBLACK, KOK.WINEBLACK, KOK.WINEBLACK, false);
    draw_rectangle_colour(X+24, Y, X+W, Y+20, KOK.PISS, KOK.PISS, KOK.PISS, KOK.PISS, false);
    draw_rectangle_colour(X, Y, X+24, Y+20, KOK.LSLATE, KOK.LSLATE, KOK.LSLATE, KOK.LSLATE, false);
    draw_rectangle_colour(X+32, Y, X+35, Y+20, KOK.LSLATE, KOK.LSLATE, KOK.LSLATE, KOK.LSLATE, false);

    if (GUID.TITLE != -1)
    {
        var title = string(GUID.TITLE);
        draw_set_valign(1);
        draw_text_colour(X+44, Y+12, title, KOK.WINEBLACK, KOK.WINEBLACK, KOK.WINEBLACK, KOK.WINEBLACK, 1);
        draw_text_colour(X+42, Y+10, title, KOK.CREAM, KOK.CREAM, KOK.CREAM, KOK.CREAM, 1);
        draw_set_valign(0);
    }
}

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
