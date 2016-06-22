% pce = mask2pce( mask, tolerance)
%------------------------------------------------------------------------
% Get the representation in terms of polygons of the contour of a mask.
% PARAMS IN:
%   mask          : Boolean matrix - foreground (true), background (false),
%                   representing the mask of the shape we want to code.
%   tolerance [3] : Tolerance in the simplification of the shape into
%                   polygons, 0 represents no loss.
% PARAMS OUT:
%   pce           : Polygonal representation of the contour.
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function pce = mask2pce( mask, tolerance)

if ~exist('tolerance','var')
    tolerance = 3;
end

% Call the C++ implementation
pce = mask2poly_mex(mask, tolerance);

end

