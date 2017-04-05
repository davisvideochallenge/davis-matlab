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
        error(['Error: ''' res_file ''' not found, have you placed your results in db_root_dir/Results/Segmentations/db_im_size/result_id?'])
    end
    result_im = imread(res_file);
    
    % Some sanity checks
    if (size(result_im,3)~=1)
        error('You are reading an image result with three channels, should have only one');
    end
    
    if db_sing_mult_obj()==0 % Single object
        if ~(all(ismember(unique(result_im),[0,255])) || all(ismember(unique(result_im),[0,1])))
            result = result_im>(max(result_im(:))/2.);
        else
            result = (result_im>0);
        end
    else % Multiple objects
        n_objs = max(result_im(:));
        if n_objs==255
            fprintf(2,'You are reading an image with a maximum value of 255, which is interpreted as having 255 different objects, are you sure that is what you want?\n');
        end
        
        % Transform it into a cell of masks
        result = cell(n_objs,1);
        for ii=1:n_objs
            result{ii} = (result_im==ii);
        end
    end
end