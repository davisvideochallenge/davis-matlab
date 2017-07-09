% [T, raw_results] =  t_stability( object, ground_truth )
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
% Calculates the temporal stability index between two masks
% ------------------------------------------------------------------------
% INPUT
%         object      Object mask.
%   ground_truth      Ground-truth mask.
%
% OUTPUT
%              T      Temporal (in-)stability
%    raw_results      Supplemental values 
% ------------------------------------------------------------------------
function [T, raw_results] = t_stability( object, ground_truth, num_objects)

    if iscell(object) % Multiple objects
        assert(iscell(ground_truth))
        if ~exist('num_objects','var')
            num_objects = max(length(object),length(ground_truth));
        end
        for ii=length(object)+1:num_objects
            if ~isempty(object)
                object{ii} = false(size(object{1}));
            elseif ~isempty(ground_truth)
                object{ii} = false(size(ground_truth{1}));
            else
                object{ii} = [];
            end
        end
        for ii=length(ground_truth)+1:num_objects
            if ~isempty(ground_truth)
                ground_truth{ii} = false(size(ground_truth{1}));
            elseif ~isempty(object)
                ground_truth{ii} = false(size(object{1}));
            else
                ground_truth{ii} = [];
            end
        end
        assert(length(object)==length(ground_truth));
    
        T = zeros(1,num_objects);
        for ii=1:num_objects
            if (isempty(object{ii}))
                T(ii) = NaN;
                raw_results{ii} = []; %#ok<AGROW>
            else
                [T(ii), raw_results{ii}] = t_stability_single(object{ii}, ground_truth{ii}); %#ok<AGROW>
            end
        end
    else
        [T, raw_results] = t_stability_single( object, ground_truth);
    end
end

function [T, raw_results] = t_stability_single( object, ground_truth )

%% Parameters
% Contour extraction parameters
cont_th = 3;
cont_th_up = 3;

% Shape context parameters
nbins_theta=12;
nbins_r=5;
r_inner=1/8;
r_outer=2;

%% Polygons and shape context
% To polygonal contour encoding
poly1 = mask2pce(object      ,cont_th);
poly2 = mask2pce(ground_truth,cont_th);

% If one of the masks is empty, return NaN
% (it will be ignored afterwards in the computation)
if isempty(poly1.paths) || isempty(poly2.paths)
    T = NaN;
    raw_results = [];
    return;
end
    
% Keep the longest closed contour <-- Can we put everything in one?
Cs1 = get_longest_cont(poly1);
Cs2 = get_longest_cont(poly2);

% Resample so that there are not too long lines
upCs1 = contour_upsample(Cs1, cont_th_up);
upCs2 = contour_upsample(Cs2, cont_th_up);

% 'Classical' shape context
nsamp1 = size(upCs1,1);
scs1 = sc_compute(upCs1',zeros(1,nsamp1),[],nbins_theta,nbins_r,r_inner,r_outer,zeros(1,nsamp1));
nsamp2 = size(upCs2,1);
scs2 = sc_compute(upCs2',zeros(1,nsamp2),[],nbins_theta,nbins_r,r_inner,r_outer,zeros(1,nsamp2));

% Compute cost matrix between pairs of points
costmat = hist_cost_2(scs1,scs2);

%% Match contours
% Match with the 0-0 alignment
[~, max_sx, max_sy] = mex_match_dijkstra( costmat );

% Shift costmat
costmat2 = circshift(costmat,[-max_sx,-max_sy]);

% Redo again with the correct alignment
pairs = mex_match_dijkstra( costmat2 );

% Put the pairs back to the original place
pairs(:,1) = mod(pairs(:,1)+max_sx-1, size(costmat,1))+1;
pairs(:,2) = mod(pairs(:,2)+max_sy-1, size(costmat,2))+1;

% Get a bijective matching
%(could be done by adding zero-cost connections in the graph)
pairs = get_bijective_matching(pairs, costmat);

% Get cost of each matching
pairs_cost = costmat(sub2ind(size(costmat), pairs(:,1), pairs(:,2)));
min_cost   = sum(pairs_cost);

%% Compute distance
% % Estimate the best (affine) transformation
% [all_dist1,all_dist2,coords2_trans] = segment_dist(upCs1,upCs2,pairs,0);
% 
% % Compute the distance between all paired (transformed) points
% pt_from = upCs1(pairs(:,1),:);
% pt_to	= coords2_trans(pairs(:,2),:);
% all_d   = sqrt((pt_from(:,1)-pt_to(:,1)).^2+(pt_from(:,2)-pt_to(:,2)).^2);
    
%% Save auxiliar results
raw_results.poly1      = poly1;
raw_results.poly2      = poly2;
raw_results.Cs1        = Cs1;
raw_results.Cs2        = Cs2;
raw_results.upCs1      = upCs1;
raw_results.upCs2      = upCs2;
raw_results.scs1       = scs1;
raw_results.scs2       = scs2;
raw_results.costmat    = costmat;
raw_results.pairs      = pairs;
raw_results.min_cost   = min_cost;
raw_results.pairs_cost = pairs_cost;
% raw_results.upCs2_tran = coords2_trans;
% raw_results.all_d_matched = all_d;
% raw_results.all_d_dist1 = all_dist1;
% raw_results.all_d_dist2 = all_dist2;

%% Compute final value of the measure
T = raw_results.min_cost/size(raw_results.pairs_cost,1);
                
end

