//Initalize camera position
C_POS = 0;
C_POS[ 0] = 0; //x
C_POS[ 1] = 0; //y
C_POS[ 2] = 0; //z

//Camera rotation
C_ROT = 0;
C_ROT[ 0] = 0; //x
C_ROT[ 1] = 0; //y
C_ROT[ 2] = 0; //z

//forward -- NOPE, NOT NEEDED
/*C_FT = 0;
C_FT[ 0] = 0;
C_FT[ 1] = 0;
C_FT[ 2] = 0;

C_UT = 0;
C_UT[ 0] = 0;
C_UT[ 1] = 0;
C_UT[ 2] = 0;

C_RT = 0;
C_RT[ 0] = 0;
C_RT[ 1] = 0;
C_RT[ 2] = 0;*/

//And velocity
P_VEL = 0;
P_VEL[ 0] = 0;
P_VEL[ 1] = 0;
P_VEL[ 2] = 0;

//And camera tilt thing
P_TILT = 0;

//And FOV & aspect
C_FOV = 85;
ASPECT = room_width / room_height;

//And matrix
CMAT = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
CROT = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);
CFROT = matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1);

//Init d3d
d3d_start();
draw_set_colour(c_white);
d3d_set_culling(true);
d3d_set_hidden(true);
