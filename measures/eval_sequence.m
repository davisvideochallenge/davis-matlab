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
    
    % Allocate
    eval_tmp = cell(length(measures));
    
    last_result = zeros(size(db_read_annot(seq_name, frame_ids{1})));
    fprintf(seq_name);
    for f_id = 2:length(frame_ids)-1
        fprintf('.');

        % Read the object annotation
        mask_gt = db_read_annot(seq_name, frame_ids{f_id});
        
        % Check size of the mask and logical values
        if ~isequal(size(mask_res{f_id-1}),size(mask_gt))
            error('The size of the input masks is not correct');
        elseif ~islogical(mask_res{f_id-1})
            error('The input mask must be a logic value');
        end
        
        % Compute J
        [ism, pos] = ismember('J',measures);
        if ism, eval_tmp{pos}(f_id-1) = jaccard_region(mask_res{f_id-1}, mask_gt); end

        % Compute F
        [ism, pos] = ismember('F',measures);
        if ism, eval_tmp{pos}(f_id-1) = f_boundary(mask_res{f_id-1}, mask_gt); end

        % Temporal (in-)stability
        [ism, pos] = ismember('T',measures);
        if ism, eval_tmp{pos}(f_id-1) = t_stability(last_result, mask_res{f_id-1}); end

        % Keep last result
        last_result = mask_res{f_id-1};
    end
    fprintf('\n');
    % F for boundaries
    [ism, pos] = ismember('F',measures);
    if ism
        curr_F = eval_tmp{pos};
        assert(~all(isnan(curr_F)));
        
        eval.F.mean   = mean(curr_F);
        eval.F.std    = std(curr_F);
        eval.F.recall = sum(curr_F>0.5)/length(curr_F);
     
        tmp = get_mean_values(curr_F,4);
        eval.F.decay  = tmp(1)-tmp(end);
    end
    
    % Jaccard
    [ism, pos] = ismember('J',measures);
    if ism
        curr_J =  eval_tmp{pos};
        
        eval.J.mean   = mean(curr_J);
        eval.J.std    = std(curr_J);
        eval.J.recall = sum(curr_J>0.5)/length(curr_J);
    
        tmp = get_mean_values(curr_J,4);
        eval.J.decay  = tmp(1)-tmp(end);
    end
    
    % Temporal stability
    [ism, pos] = ismember('T',measures);
    if ism
        curr_T = eval_tmp{pos};
        eval.T.mean   = 5*nanmean(curr_T); % NaN mean to erase NaN from empty masks
                                                 % Multiply by 5 to put it in a similar
                                                 %  range than other measures
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