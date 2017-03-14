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

if ~iscell(measures)
    measures = {measures};
end

%% Compute the raw evaluation or load it from file
to_recompute = {};
for ii=1:length(measures)
    res_file = fullfile(eval_folder, [result_id '_' measures{ii} '_' gt_set '_' db_get_properties '.mat']);
    if exist(res_file,'file')
        raw_eval.(measures{ii}) = loadvar(res_file,'raw_ev');
        disp(['LOADED: ' res_file])
    else
        to_recompute{end+1} = measures{ii}; %#ok<AGROW>
    end
end

if ~isempty(to_recompute)
    for ii=1:length(to_recompute)
        res_file = fullfile(eval_folder, [result_id '_' to_recompute{ii} '_' gt_set '_' db_get_properties '.mat']);
        disp(['RECOMPUTING: ' res_file])
    end
    
    % Compute them all in one pass, not to read things twice
    sel_eval = recompute_raw_eval(result_id, to_recompute, gt_set);
    
    % Separate each measure and save them independently
    for ii=1:length(to_recompute)
        res_file = fullfile(eval_folder, [result_id '_' to_recompute{ii} '_' gt_set '_' db_get_properties '.mat']);
        disp(['SAVING: ' res_file])

        raw_ev = sel_eval.(to_recompute{ii});
        save(res_file,'raw_ev','-v7.3');
        
        raw_eval.(to_recompute{ii}) = raw_ev;
        clear raw_ev;
    end
    clear sel_eval;
end
    
%% Put everything in a single matrix
for ii=1:length(measures)
    eval.(measures{ii}).mean = [raw_eval.(measures{ii}).mean];
    if ~strcmp(measures{ii},'T')
        eval.(measures{ii}).recall = [raw_eval.(measures{ii}).recall];
        eval.(measures{ii}).decay = [raw_eval.(measures{ii}).decay];
    end
    
    % Store per-frame results
    seq_ids = db_seqs(gt_set);
    eval.(measures{ii}).raw = cell(1,length(seq_ids));
    for jj=1:length(seq_ids)
        eval.(measures{ii}).raw{jj} = raw_eval.(measures{ii})(jj).raw;
    end
end

end




function [eval, seq_ids] = recompute_raw_eval(result_id, measures, gt_set)
    % Get the ids of all sequences
    seq_ids = db_seqs(gt_set);

    % Sweep all sequences
    for s_id = 1:length(seq_ids)

        % Get all frame ids for that sequence
        frame_ids = db_frame_ids(seq_ids{s_id});

        % Allocate
        masks_seq = cell(length(frame_ids)-2,1);
        
        % Read all frames except first and last
        for f_id = 2:length(frame_ids)-1
            % Read a result (or ground truth in case of "gt")
            if strcmp(result_id,'gt')
                masks_seq{f_id-1} = db_read_annot(seq_ids{s_id}, frame_ids{f_id});
            else
                masks_seq{f_id-1} = db_read_result(seq_ids{s_id}, frame_ids{f_id}, result_id);
            end
        end
        
        % Evaluate these masks
        tmp_eval = eval_sequence(masks_seq, seq_ids{s_id}, measures);
        for ii=1:length(measures)
            eval.(measures{ii})(s_id) = tmp_eval.(measures{ii});
        end
    end
end
