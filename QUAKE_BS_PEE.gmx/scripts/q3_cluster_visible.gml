///q3_cluster_visible(currentCluster, testingOne, bitsetBuffer)
var C1 = argument0;
var C2 = argument1;

var BITS = argument2;//VISDATA[@ 2];

if (BITS == 0 || C1 < 0) return true;

//Some bitwise shit #1 :
//The (C2 >> 3) is same as (C2 div 8).
// NOTE 2018 : Oh please watch your damn mouth, 2017 me >:(
// Anyway, As you see, I used some weird bit majick to juice out some sweet FPS there.

var IND = (C1 * VISDATA[@ 1]) + (C2 >> 3);
var BITSET = buffer_peek(BITS, IND, buffer_u8);

return ( (BITSET & (1 << (C2 & 7))) != 0);
