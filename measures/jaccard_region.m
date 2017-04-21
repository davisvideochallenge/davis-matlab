%[J, inters, fp, fn] = jaccard( object, ground_truth )
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
% Calculates the Jaccard index (overlap, intersection over union) between two masks
%
% INPUT
%         object      Object mask.
%   ground_truth      Ground-truth mask.
%
% OUTPUT
%              J       Jaccard index
%         inters       Area of the interesection between the two masks
%             fp       Area of the false positives
%             fn       Area of the false negatives
%
% ------------------------------------------------------------------------
function [J, inters, fp, fn] = jaccard_region( object, ground_truth, num_objects )

    if iscell(object) % Multiple objects
        assert(iscell(ground_truth))
        if ~exist('num_objects','var')
            num_objects = max(length(object),length(ground_truth));
        end
        for ii=length(object)+1:num_objects
            object{ii} = false(size(ground_truth{1}));
        end
        for ii=length(ground_truth)+1:num_objects
            ground_truth{ii} = false(size(ground_truth{1}));
        end
        assert(length(object)==length(ground_truth));
    
        J  = zeros(1,num_objects); inters = zeros(1,num_objects);
        fp = zeros(1,num_objects); fn     = zeros(1,num_objects);
        for ii=1:num_objects
            [J(ii), inters(ii), fp(ii), fn(ii)] = jaccard_single(object{ii}, ground_truth{ii});
        end
    else
        [J, inters, fp, fn] = jaccard_single( object, ground_truth );
    end
    
    

end



function [J, inters, fp, fn] = jaccard_single( object, ground_truth )

% Make sure they're binary
object       = logical(object);
ground_truth = logical(ground_truth);

% Intersection between all sets
inters = object.*ground_truth;
fp     = object.*(1-inters);
fn     = ground_truth.*(1-inters);

% Areas of the intersections
inters = sum(inters(:)); % Intersection
fp     = sum(fp(:)); % False positives
fn     = sum(fn(:)); % False negatives

% Compute the fraction
denom = inters + fp + fn;
if denom==0
    J = 1;
else
    J =  inters/denom;
end
end

