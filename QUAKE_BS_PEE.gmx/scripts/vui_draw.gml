///vui_draw(WHoooYYyYAaaA_SHIT)
var GUIELEM = guiELEMENT;
var GUI;

for (var i=0;i<ds_grid_height(GUIELEM);i++)
{
    GUI = GUIELEM[# 0,i];
    
    if (GUI.visible)
    {
        vui_draw_gui(GUI);
    }
}
