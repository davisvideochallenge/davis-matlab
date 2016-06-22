% pce = pce_read( filename ) 
%------------------------------------------------------------------------
% Get the area of a polygon contour.
% PARAMS IN:
%   filename  : File name to write the polygon
% PARAMS OUT:
%   pce       : Polygonal representation of the contour.
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function pce = pce_read( filename ) 
    % Call the C++ implementation
    pce = poly_read_mex(filename);
end

