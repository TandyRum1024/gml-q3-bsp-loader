///zbsp_atlas_end()
/*
    Ends building the texture atlas by compilling it & returns the array of surfaces
*/

var _atlasdata = ds_list_create();
var _atlases = -1, _atlasidx = 0;
var _maxw = 0, _maxh = 0;
var _nextx = 0, _nexty = 0;

// 1] Copy rects into special formated grid that we can sort
var _rectnum = ds_list_size(zbspAtlasRectList);
var _tempgrid = ds_grid_create(4, _rectnum);

for (var i=0; i<_rectnum; i++)
{
    var _data = zbspAtlasRectList[| i];
    
    // array
    _tempgrid[# 0, i] = _data;
    
    // texture atlas index
    _tempgrid[# 1, i] = 0;
    
    // sort basis (height)
    _tempgrid[# 2, i] = _data[@ 5];
    
    _data[@ 2] = -420 - _data[@ 4];
    _data[@ 5] = -420 - _data[@ 5];
}

// 2] Sort special grid by height
ds_grid_sort(_tempgrid, 2, false);

// 3] Pack er' up!
// https://jsfiddle.net/jLchftot/
var _margin = 0;
for (var i=0; i<_rectnum; i++)
{
    var _data = _tempgrid[# 0, i];
    _data[@ 1] = _atlasidx;
    
    var _currentw = _data[@ 4];
    var _currenth = _data[@ 5];
    
    if (_maxw == 0) // First texture to place on the atlas
    {
        _data[@ 2] = 0;
        _data[@ 3] = 0;
        _nextx += _currentw + _margin;
    }
    else
    {
        // check if we can somehow shove the box into the given area (minimize the wasted space)
        var _found = false;
        
        for (var _x=0; _x<_maxw; _x++)
        {
            for (var _y=0; _y<_maxw; _y++)
            {
                // check against all other boxes
                for (var j=0; j<_rectnum; j++)
                {
                    if (j == i)
                        continue;
                    
                    var _other = _tempgrid[# 0, j];
                    
                    if (!(_other[ 2] + _other[ 4] + _margin < _x || _other[ 2] > _x + _data[ 4] + _margin ||
                        _other[ 3] + _other[ 5] + _margin < _y || _other[ 3] > _y + _data[ 5] + _margin))//(!rectangle_in_rectangle(_data[@ 2] - _margin, _data[@ 3] - _margin, _data[@ 2] + _currentw + _margin, _data[@ 3] + _currenth + _margin, _other[@ 2], _other[@ 3], _other[@ 2] + _other[@ 4], _other[@ 3] + _other[@ 5]))
                    {
                        show_debug_message("FOUND SPACE");
                        _found = true;
                        _data[@ 2] = _x;
                        _data[@ 3] = _y;
                        break;
                    }
                }
                if (_found) break;
            }
            if (_found) break;
        }
        
        // if we can't shove the box in, place it in the new space
        if (!_found)
        {
            show_debug_message("NO SPACE");
            if (_nextx + _currentw > _maxh)
            {
                _nextx = 0;
                _nexty = _maxh;
            }
            
            _data[@ 2] = _nextx;
            _data[@ 3] = _nexty;
            
            _nextx += _currentw + _margin;
        }
    }
    
    // re-calculate max size of texture atlas
    _maxw = max(_data[@ 2] + _data[@ 4] + _margin, _maxw);
    _maxh = max(_data[@ 3] + _data[@ 5] + _margin, _maxh);
}
ds_grid_destroy(_tempgrid);

// 4] Build surfaces
_atlases = surface_create(_maxw, _maxh);
surface_set_target(_atlases);
draw_clear(c_white);
for (var i=0; i<ds_list_size(zbspAtlasRectList); i++)
{
    var _data = zbspAtlasRectList[| i];
    draw_sprite(_data[@ 0], 0, _data[@ 2], _data[@ 3]);
}
surface_reset_target();
/*
for (var i=0; i<ds_list_size(_atlasdata); i++)
{
    var _adata = _atlasdata[| i];
    var _surfw = _adata[@ 0];
    var _surfh = _adata[@ 1];
    var _textures = _adata[@ 2];
    
    _atlases[i] = surface_create(_surfw, _surfh);
    surface_set_target(_atlases[i]);
    draw_clear(c_red);
    for (var i=0; i<ds_list_size(_textures); i++)
    {
        var _data = _textures[| i];
        draw_sprite(_data[@ 0], 0, _data[@ 2], _data[@ 3]);
    }
    surface_reset_target();
}
*/
/*
zbspAtlasSurface = surface_create(zbspAtlasWidth, zbspAtlasHeight);
surface_set_target(zbspAtlasSurface);
*/
return _atlases;
