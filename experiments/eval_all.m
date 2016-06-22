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
% Evaluate all techniques in parallel
% ------------------------------------------------------------------------
function eval_all(measures)

if nargin==0
    error('Parameter ''measures'' not defined')
end

% Get the parameters (list of techniques)
experiments_params();

% Evaluate in parallel
p = parpool();
parfor ii=1:length(techniques) %#ok<USENS>
    eval_result(techniques{ii},measures);  %#ok<PFIIN>
end
delete(p);

