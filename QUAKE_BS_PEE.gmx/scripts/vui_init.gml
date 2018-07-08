/*
    WTF, GUI-villain?
    
     - An UI script by PISSENWYY (AKA Tandy rum 1024.)
    -----------------
    
    The gui consists of ::
     - A depth. (For depth sorting?)
     - List of items/ui. (Y' know what to do)
     - STYLE (NADA/COLOUR/TILED/DOS)
      :: NADA - Nothing. SEE-THRU
      :: COLOUR - Single coloured box.
      :: TILED - FaAaAaAAAancy tiled box.
      :: DOS - DOS-LIKE box.
*/
//Enum for easy referencing
enum uiTYPE
{
    PANEL = 0,
    texPANEL = 1,
    LABEL = 2,
    BUTTON = 3
}

//GUIELMENTS [ GUI_instance, DEPTH]
guiELEMENT = ds_grid_create(2,0);

//Update Depth?
guiUPDATEPLZ = true;
