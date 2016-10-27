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
function [eval, raw_eval] = eval_result(result_id, measures, gt_set)

% Pre-computed evaluations are stored here
eval_folder = fullfile(db_matlab_root_dir,'eval_results');
if ~exist(eval_folder,'dir')
    mkdir(eval_folder)
end

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

%% Compute the raw evaluation or load it from file
to_recompute = {};
for ii=1:length(measures)
    res_file = fullfile(eval_folder, [result_id '_' measures{ii} '_' gt_set '.mat']);
    if exist(res_file,'file')
        raw_eval.(measures{ii}) = loadvar(res_file,'raw_ev');
        disp(['LOADED: ' res_file])
    else
        to_recompute{end+1} = measures{ii}; %#ok<AGROW>
    end
end

if ~isempty(to_recompute)
    for ii=1:length(to_recompute)
        res_file = fullfile(eval_folder, [result_id '_' to_recompute{ii} '_' gt_set '.mat']);
        disp(['RECOMPUTING: ' res_file])
    end
    
    % Compute them all in one pass, not to read things twice
    sel_eval = recompute_raw_eval(result_id, to_recompute, gt_set);
    
    % Separate each measure and save them independently
    for ii=1:length(to_recompute)
        res_file = fullfile(eval_folder, [result_id '_' to_recompute{ii} '_' gt_set '.mat']);
        disp(['SAVING: ' res_file])

        raw_ev = sel_eval(ii,:);
        save(res_file,'raw_ev','-v7.3');
        
        raw_eval.(to_recompute{ii}) = raw_ev;
        clear raw_ev;
    end
    clear sel_eval;
end
    
%% Get per-seq mean quality, decay, and recall

% Get the ids of all sequences
seq_ids = db_seqs(gt_set);

% Allocate
if ismember('F',measures)
    eval.F.mean   = zeros(1,length(seq_ids));
    eval.F.std    = zeros(1,length(seq_ids));
    eval.F.recall = zeros(1,length(seq_ids));
    eval.F.decay  = zeros(1,length(seq_ids));
    assert(length(seq_ids)==length(raw_eval.F))
end
if ismember('J',measures)
    eval.J.mean   = zeros(1,length(seq_ids));
    eval.J.std    = zeros(1,length(seq_ids));
    eval.J.recall = zeros(1,length(seq_ids));
    eval.J.decay  = zeros(1,length(seq_ids));
    assert(length(seq_ids)==length(raw_eval.J))

end
if ismember('T',measures)
    eval.T.mean   = zeros(1,length(seq_ids));
    assert(length(seq_ids)==length(raw_eval.T))
end


% Sweep all sequences
for s_id = 1:length(seq_ids)

    % F for boundaries
    if ismember('F',measures)
        curr_F = raw_eval.F{s_id};
        assert(~all(isnan(curr_F)));
        
        eval.F.mean(s_id)   = mean(curr_F);
        eval.F.std(s_id)    = std(curr_F);
        eval.F.recall(s_id) = sum(curr_F>0.5)/length(curr_F);
     
        tmp = get_mean_values(curr_F,4);
        eval.F.decay(s_id)  = tmp(1)-tmp(end);
    end
    
    % Jaccard
    if ismember('J',measures)
        curr_J = raw_eval.J{s_id};
        
        eval.J.mean(s_id)   = mean(curr_J);
        eval.J.std(s_id)    = std(curr_J);
        eval.J.recall(s_id) = sum(curr_J>0.5)/length(curr_J);
    
        tmp = get_mean_values(curr_J,4);
        eval.J.decay(s_id)  = tmp(1)-tmp(end);
    end
    
    % Temporal stability
    if ismember('T',measures)
        curr_T = raw_eval.T{s_id};
        eval.T.mean(s_id)   = 5*nanmean(curr_T); % NaN mean to erase NaN from empty masks
                                                 % Multiply by 5 to put it in a similar
                                                 %  range than other measures
    end
end


end




function [eval, seq_ids] = recompute_raw_eval(result_id, measures, gt_set)
    % Get the ids of all sequences
    seq_ids = db_seqs(gt_set);

    % Allocate
    eval = cell(length(measures),length(seq_ids));

    % Sweep all sequences
    for s_id = 1:length(seq_ids)

        % Get all frame ids for that sequence
        frame_ids = db_frame_ids(seq_ids{s_id});
        fprintf('%s',seq_ids{s_id});

        % Sweep all frames except first and last
        last_result = zeros(size(db_read_annot(seq_ids{s_id}, frame_ids{1})));
        for f_id = 2:length(frame_ids)-1
            fprintf('.');

            % Read the object annotation
            annot = db_read_annot(seq_ids{s_id}, frame_ids{f_id});

            % Read a result (or ground truth in case of "gt")
            if strcmp(result_id,'gt')
                result = db_read_annot(seq_ids{s_id}, frame_ids{f_id});
            else
                result = db_read_result(seq_ids{s_id}, frame_ids{f_id}, result_id);
            end

            % Compute J
            [ism, pos] = ismember('J',measures);
            if ism, eval{pos,s_id}(f_id-1) = jaccard_region(result, annot); end
            
            % Compute F
            [ism, pos] = ismember('F',measures);
            if ism, eval{pos,s_id}(f_id-1) = f_boundary(result, annot); end
            
            % Temporal (in-)stability
            [ism, pos] = ismember('T',measures);
            if ism, eval{pos,s_id}(f_id-1) = t_stability(last_result, result); end
            
            % Keep last result
            last_result = result;
        end

        fprintf('\n');
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
