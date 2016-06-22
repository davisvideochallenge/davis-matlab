% area = pce_area( pce )
%------------------------------------------------------------------------
% Get the area of a polygon contour.
% PARAMS IN:
%   pce   : Polygonal representation of the contour.
% PARAMS OUT:
%   area  : Area of the polygon.       
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function area = pce_area( pce )
    % Call the C++ implementation
    area = poly_area_mex(pce);
end

