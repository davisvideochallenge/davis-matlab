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
function [all_d1, all_d2, coords2_trans] = segment_dist( coords1, coords2, pairs, debug )

    % Warp one segment into the other
    anchors1 = coords1(pairs(:,1),:);
    anchors2 = coords2(pairs(:,2),:);

    % Estimate affine transformation
    trans = cp2tform(anchors2,anchors1,'nonreflective similarity');
    
    % Project all points using the estimated transform
    coords2_trans = tformfwd(trans, coords2);
    
    % Compute distance of all points in 1 to projected points in 2
    [~, all_d1] = points_dist(coords1, coords2_trans);
    [~, all_d2] = points_dist(coords2_trans, coords1);
    
    % Plot to debug
    if debug
        figure; 
        hold on;
        set(gcf,'color','w');

        plot(coords2_trans(:,1),coords2_trans(:,2),'k-', ...
             coords1(:,1), coords1(:,2),'r--',...
             'linewidth',.5);
        axis equal;	axis ij; axis off;
    end
    
end

