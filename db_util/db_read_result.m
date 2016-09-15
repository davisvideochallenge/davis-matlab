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
function result = db_read_result(seq_id, frame_id, result_id)
    res_file = fullfile(db_results_dir, result_id, seq_id, [frame_id '.png']);
    if ~exist(res_file,'file')
        error(['Error: ''' res_file ''' not found, have you downloaded the DAVIS results from the project website?'])
    end
    result = imread(res_file);
    assert(size(result,3)==1)
    assert(all(ismember(unique(result),[0,255])) || all(ismember(unique(result),[0,1])))
    result = (result>0);
end