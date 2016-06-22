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
function bij_pairs = get_bijective_matching(pairs, costmat)
    bij_pairs = bij_pairs_one_dim(pairs, costmat,0);
    bij_pairs = bij_pairs_one_dim(bij_pairs, costmat',1);
end

function bij_pairs = bij_pairs_one_dim(pairs, costmat, left_or_right)
    bij_pairs = [];
    ids1 = unique(pairs(:,1+left_or_right));
    for ii=1:length(ids1)
        curr_pairs = pairs(pairs(:,1+left_or_right)==ids1(ii),:);
        
        curr_costs = costmat(sub2ind(size(costmat), curr_pairs(:,1+left_or_right), curr_pairs(:,2-left_or_right)));
        [~,b] = min(curr_costs);
        
        bij_pairs = [bij_pairs; curr_pairs(b,:)]; %#ok<AGROW>
    end
end