% ------------------------------------------------------------------------ 
% Jordi Pont-Tuset - http://jponttuset.github.io/
% April 2016
% ------------------------------------------------------------------------ 
% This file is part of the DAVIS package presented in:
%   Federico Perazzi, Jordi Pont-Tuset, Brian McWilliams,
%   Luc Van Gool, Markus Gross, Alexander Sorkine-Hornung
%   A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation
%   CVPR 2016
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
function conts = get_longest_cont(poly)
    max_length = 0;
    for jj=1:length(poly.paths)
        if (max_length < size(poly.paths(jj).contour_coords,1))
            max_length = size(poly.paths(jj).contour_coords,1);
            conts = double(poly.paths(jj).contour_coords);
        end
    end
end