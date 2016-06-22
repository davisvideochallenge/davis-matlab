% intersection = pce_intersection( pce1, pce2 )
%------------------------------------------------------------------------
% Get the intersection between two polygon contours.
% PARAMS IN:
%   pce1, pce2    : Polygonal representations of the contours.
% PARAMS OUT:
%   intersection  : Intersection between the two polygons.       
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function intersection = pce_intersection( pce1, pce2 )
    % Call the C++ implementation
    intersection = poly_intersection_mex(pce1, pce2);
end

