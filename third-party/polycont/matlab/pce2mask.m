% mask = pce2mask( pce )
%------------------------------------------------------------------------
% Get the representation in terms of polygons of the contour of a mask.
% PARAMS IN:
%   pce           : Polygonal representation of the contour.
% PARAMS OUT:
%   mask          : Boolean matrix - foreground (true), background (false),
%                   representing the mask of the shape we want to code.
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function mask = pce2mask( pce )

% Call the C++ implementation
mask = poly2mask_mex(pce);

end

