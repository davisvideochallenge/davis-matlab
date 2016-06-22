% [jaccard, precision, recall] = pce_jaccard( pce1, pce2 )
%------------------------------------------------------------------------
% Get the jaccard index between two polygon contours.
% PARAMS IN:
%   pce1, pce2  : Polygonal representations of the contours.
% PARAMS OUT:
%   jaccard     : Jaccard index between two polygon contours.        
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function [jaccard, precision, recall] = pce_jaccard( pce1, pce2 )
    % Get the areas
    area1 = pce_area(pce1);
    area2 = pce_area(pce2);
    
    % Get the intersection
    inters = pce_intersection(pce1, pce2);
    
    % Get the union
    union = area1+area2-inters;
    
    % Get the Jaccard
    if union==0
        jaccard   = 1;
        precision = 1;
        recall    = 1;
    else
        jaccard   = inters/union;
        precision = inters/area1;
        recall    = inters/area2;
    end
end

