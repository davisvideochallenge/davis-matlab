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
function [d, all_d] = points_dist(coords1, coords2)

% Compute distance of all points in 1 to closest points in 2
all_d = zeros(size(coords1,1),1);
for ii=1:size(coords1,1)
    all_d(ii) = abs(p_poly_dist(coords1(ii,1),coords1(ii,2),coords2(:,1),coords2(:,2)));
end

% Mean distance
d = mean(all_d);

