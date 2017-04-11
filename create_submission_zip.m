% ------------------------------------------------------------------------ 
% Jordi Pont-Tuset - http://jponttuset.cat/
% April 2017
% ------------------------------------------------------------------------ 
% This file is part of the DAVIS package presented in:
%   Jordi Pont-Tuset, Federico Perazzi, Sergi Caelles,
%   Pablo Arbeláez, Alexander Sorkine-Hornung, Luc Van Gool
%   The 2017 DAVIS Video Object Segmentation Challenge
%   arXiv 2017
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------

% Name of a result technique
results_folder = '/Users/jpont/Workspace/datasets/DAVIS-2017/Segmentations/480p/osvos';

% This sets up DAVIS
startup;

% Set the properties of DAVIS:
%  - 2017 is the year of the DAVIS edition
%  - 1 means multiple objects, 0 single object
%  - '480p' or 'Full-Resolution'
db_set_properties(2017, 1,'480p');

% Get the ids of all sequences
seq_ids = db_seqs('test-dev');

%% Sweep all sequences to check everything is fine
for s_id = 1:length(seq_ids)
    
    % Get all frame ids for that sequence
    frame_ids = db_frame_ids(seq_ids{s_id});
    fprintf('%s',seq_ids{s_id});
    
    % Read the ground truth
    gt = db_read_annot(seq_ids{s_id},frame_ids{1});
    n_objs = length(gt);
    
    % Sweep all frames
    for f_id = 2:length(frame_ids)-1
        fprintf('.');
        
        % Read a result
        res_file = fullfile(results_folder,seq_ids{s_id},[frame_ids{f_id} '.png']);
        result = db_read_result(res_file);
        
        if (length(result)>n_objs)
            error(['Result ''' res_file ''' has more objects than the ground truth'])
        end
    end
    fprintf('\n');
end


%% Create zip file, without root folder (otherwise Codalab breaks)
res_zip = fullfile(db_matlab_root_dir, 'results_for_codalab.zip');
system(['cd ' results_folder '; zip -r ' res_zip ' *']);
disp(['Your submission is ready in: ' res_zip])




