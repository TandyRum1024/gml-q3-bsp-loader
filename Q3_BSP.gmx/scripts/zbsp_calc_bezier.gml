///zbsp_calc_bezier(a, b, c, lerpi2, lerp2, lil2)
/*
    Calculates bezier curve with 3 controls
    lerpi2 : (1 - t) ^ 2
    lerp2 : t ^ 2
    lil2 : t * (1 - t) * 2
*/

var _lerpi2 = argument3;
var _lerp2 = argument4;
var _2lil = argument5;

return argument0 * _lerpi2 + argument1 * _2lil + argument2 * _lerp2;
