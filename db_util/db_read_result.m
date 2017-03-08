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
    result_im = imread(res_file);
    
    % Some sanity checks
    assert(size(result_im,3)==1)
    
    if db_sing_mult_obj()==0 % Single object
        if ~(all(ismember(unique(result_im),[0,255])) || all(ismember(unique(result_im),[0,1])))
            result = result_im>(max(result_im(:))/2.);
        else
            result = (result_im>0);
        end
    else % Multiple objects
        n_objs = length(unique(result_im))-1;
        assert(isequal(uint8((0:n_objs)'),unique(result_im)))
        
        % Transform it into a cell of masks
        result = cell(n_objs,1);
        for ii=1:n_objs
            result{ii} = (result_im==ii);
        end
    end
end