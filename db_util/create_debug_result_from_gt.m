function create_debug_result_from_gt()

% Name of a result technique
result_id = 'gt-debug';

res_dir = fullfile(db_results_dir, result_id);
if ~exist(res_dir,'dir')
    mkdir(res_dir)
end

% Get the ids of all sequences
seq_ids = db_seqs('debug-2017');

% Sweep all sequences
for s_id = 1:length(seq_ids)
    
    % Get all frame ids for that sequence
    frame_ids = db_frame_ids(seq_ids{s_id});
    fprintf('%s',seq_ids{s_id});
    
    seq_dir = fullfile(res_dir,seq_ids{s_id});
    if ~exist(seq_dir,'dir')
        mkdir(seq_dir)
    end
    
    % Sweep all frames
    for f_id = 1:length(frame_ids)
        fprintf('.');
        
        % Read the object annotation
        annot  = db_read_annot(seq_ids{s_id}, frame_ids{f_id});
        
        % Write a result
        db_write_result(annot,fullfile(seq_dir,[frame_ids{f_id} '.png']))
    end
    fprintf('\n');
end







