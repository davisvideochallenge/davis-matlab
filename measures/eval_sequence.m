% ------------------------------------------------------------------------ 
% Sergi Caelles, October 2016
% Jordi Pont-Tuset, March 2017
% ------------------------------------------------------------------------ 
% This file is part of the DAVIS package presented in:
%   Federico Perazzi, Jordi Pont-Tuset, Brian McWilliams,
%   Luc Van Gool, Markus Gross, Alexander Sorkine-Hornung
%   A Benchmark Dataset and Evaluation Methodology for Video Object Segmentation
%   CVPR 2016
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
function eval = eval_sequence(mask_res_in, seq_name, measures)
    
    % Check measures
    if ischar(measures)
        measures = {measures};
    end
    if ~iscell(measures)
        error('Measures must be a cell or a single char')
    end
    if ~all(ismember(measures,{'J','F','T'}))
        error('Measures not valid, must be in: ''J'',''F'', ''T''')
    end
    
    % Get all frames of the sequence
    frame_ids = db_frame_ids(seq_name);
    
    % Sweep all frames except first and last
    if length(mask_res_in) == length(frame_ids)
        mask_res = mask_res_in(2:end-1);
    elseif length(mask_res_in) == length(frame_ids)-2
        mask_res = mask_res_in;
    else
        error('The number of input masks is not correct.')
    end
    
    % Get number of objects (GT in the first frame)
    mask_gt = db_read_annot(seq_name, frame_ids{1});
    if iscell(mask_gt)
        n_obj = length(mask_gt);
    else
        n_obj = 1;
    end
    
    % Allocate
    for ii=1:length(measures)
        frame_eval.(measures{ii}) = zeros(length(frame_ids)-2,n_obj);
    end

    last_result = db_read_annot(seq_name, frame_ids{1});
    fprintf(seq_name);
    for f_id = 2:length(frame_ids)-1
        fprintf('.');

        % Read the object annotation
        mask_gt = db_read_annot(seq_name, frame_ids{f_id});
        
        % Check size of the mask and logical values
        if iscell(mask_gt)
            if ~isequal(length(mask_res{f_id-1}),length(mask_gt))
                error('The number of objects in the result is not the same than in the ground truth');
            elseif ~isequal(size(mask_res{f_id-1}{1}),size(mask_gt{1}))
                error('Size of results and ground truth are not the same');
            elseif ~islogical(mask_res{f_id-1}{1})
                error('The input mask must be a logical value');
            end
        else
            if ~isequal(size(mask_res{f_id-1}),size(mask_gt))
                error('Size of results and ground truth are not the same');
            elseif ~islogical(mask_res{f_id-1})
                error('The input mask must be a logical value');
            end
        end
        
        % Compute the measures in this particular frame
        tmp_eval = eval_frame(mask_res{f_id-1}, measures, mask_gt, n_obj, last_result);
        for ii=1:length(measures)
            frame_eval.(measures{ii})(f_id-1,:) = tmp_eval.(measures{ii});
        end
       
        % Keep last result
        last_result = mask_res{f_id-1};
    end
    fprintf('\n');
    
    % F for boundaries
    if ismember('F',measures)
        assert(~all(isnan(frame_eval.F(:))));
        
        eval.F.mean   = mean(frame_eval.F,1);
        eval.F.std    = std(frame_eval.F,1);
        eval.F.recall = sum(frame_eval.F>0.5,1)/size(frame_eval.F,1);
        
        for ii=1:n_obj
            tmp = get_mean_values(frame_eval.F(:,ii),4);
            eval.F.decay(ii)  = tmp(1)-tmp(end);
        end
        
        % Store per-frame results
        eval.F.raw = frame_eval.F;
    end
    
    % Jaccard
    if ismember('J',measures)
        eval.J.mean   = mean(frame_eval.J,1);
        eval.J.std    = std(frame_eval.J,1);
        eval.J.recall = sum(frame_eval.J>0.5,1)/size(frame_eval.J,1);
        
        for ii=1:n_obj
            tmp = get_mean_values(frame_eval.J(:,ii),4);
            eval.J.decay(ii)  = tmp(1)-tmp(end);
        end
        
        % Store per-frame results
        eval.J.raw = frame_eval.J;
    end
    
    % Temporal stability
    if ismember('T',measures)
        eval.T.mean   = 5*nanmean(frame_eval.T,1); % NaN mean to erase NaN from empty masks
                                                   % Multiply by 5 to put it in a similar
                                                   %  range than other measures
                                                   
               
        % Store per-frame results
        eval.T.raw = frame_eval.T;
    end 
    
end

function mvals = get_mean_values(values,N_bins)
    % Get four mean values to see how the quality evolves with time
    ids = round(linspace(1, length(values),N_bins+1));
    mvals = zeros(1,length(ids)-1);
    for jj=1:(length(ids)-1)
       mvals(jj) = mean(values(ids(jj):ids(jj+1)));
    end
end