///zbsp_vb_face(vb, x1, y1, z1, x2, y2, z2, x3, y3, z3, x4, y4, z4, colour)
/*
    Appends face vertices in given vertex buffer with format [position3d, colour]
*/
var _vb = argument0;
var _x1 = argument1, _y1 = argument2, _z1 = argument3;
var _x2 = argument4, _y2 = argument5, _z2 = argument6;
var _x3 = argument7, _y3 = argument8, _z3 = argument9;
var _x4 = argument10, _y4 = argument11, _z4 = argument12;
var _col = argument13;

// build mesh
vertex_position_3d(_vb, _x1, _y1, _z1); vertex_colour(_vb, _col, 1);
vertex_position_3d(_vb, _x2, _y2, _z2); vertex_colour(_vb, _col, 1);
vertex_position_3d(_vb, _x3, _y3, _z3); vertex_colour(_vb, _col, 1);
vertex_position_3d(_vb, _x3, _y3, _z3); vertex_colour(_vb, _col, 1);
vertex_position_3d(_vb, _x4, _y4, _z4); vertex_colour(_vb, _col, 1);
vertex_position_3d(_vb, _x2, _y2, _z2); vertex_colour(_vb, _col, 1);
