% pce_write( pce, filename )
%------------------------------------------------------------------------
% Get the area of a polygon contour.
% PARAMS IN:
%   pce       : Polygonal representation of the contour.
%   filename  : File name to write the polygon
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function pce_write( pce, filename )
    % Call the C++ implementation
    poly_write_mex(pce, filename);
end

