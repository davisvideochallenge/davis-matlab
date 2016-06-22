% [precision, recall] = f_boundary(foreground_mask,gt_mask,bound_th)
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
% Calculates precision/recall for boundaries between foreground_mask and
% gt_mask using morphological operatons to speed it up.
% ------------------------------------------------------------------------
% INPUT
%	foreground_mask   Foreground mask.
%	gt_mask           Ground-truth mask.
%   bound_th [0.008]  Boundary threshold to consider contours matched as:
%                      - A percentage of the image diagonal (if < 1)
%                      - Number of pixels (if >=1)
%
% OUTPUT
%   F           F measure for boundaries.
%	precision	Precision for boundaries.
%	recall   	Recall for boundaries.
%
% ------------------------------------------------------------------------
function [F, precision, recall] = f_boundary(foreground_mask,gt_mask,bound_th)


% Default threshold
if ~exist('bound_th','var')
    bound_th = 0.008;
end

% Get the amount of distance in pixels
if bound_th>=1
    bound_pix = bound_th;
else
    bound_pix = ceil(bound_th*sqrt(size(foreground_mask,1)^2+size(foreground_mask,2)^2));
end

% Get the pixel boundaries of both masks
fg_boundary = seg2bmap(foreground_mask);
gt_boundary = seg2bmap(gt_mask);

[X, Y] = meshgrid(-bound_pix:bound_pix,-bound_pix:bound_pix);
disk   =  (X .^ 2 + Y .^ 2) <= bound_pix .^ 2;

% Dilate them
fg_dil = imdilate(fg_boundary,strel(disk));
gt_dil = imdilate(gt_boundary,strel(disk));

% Get the intersection
gt_match = gt_boundary.*fg_dil;
fg_match = fg_boundary.*gt_dil;

% Area of the intersection
n_fg     = sum(fg_boundary(:));
n_gt     = sum(gt_boundary(:));

% Compute precision and recall
if (n_fg==0) && (n_gt>0)
    precision = 1;
    recall    = 0;
elseif (n_fg>0) && (n_gt==0)
    precision = 0;
    recall    = 1;
elseif (n_fg==0) && (n_gt==0)
    precision = 1;
    recall    = 1;
else
    precision = sum(fg_match(:))/n_fg;
    recall    = sum(gt_match(:))/n_gt;
end

% Compute F measure
if (precision+recall==0)
    F = 0;
else
    F = 2*precision*recall/(precision+recall);
end

end
