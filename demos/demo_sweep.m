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
% This script simply reads all images, annotations and
% shows how to sweep all results
% ------------------------------------------------------------------------

addpath(fullfile(db_matlab_root_dir,'db_util'));

% Name of a result technique
%result_id = 'fcp';

% Get the ids of all sequences
seq_ids = db_seqs('TrainVal');

% Sweep all sequences
for s_id = 1:length(seq_ids)
    
    % Get all frame ids for that sequence
    frame_ids = db_frame_ids(seq_ids{s_id});
    fprintf('%s',seq_ids{s_id});
    
    % Sweep all frames
    for f_id = 2:length(frame_ids)-1
        fprintf('.');

        % Read the original image
        image  = db_read_image(seq_ids{s_id}, frame_ids{f_id});
        
        % Read the object annotation
        annot  = db_read_annot(seq_ids{s_id}, frame_ids{f_id});
        
        % Read a result
        %result = db_read_result(seq_ids{s_id}, frame_ids{f_id}, result_id); 
    end
    fprintf('\n');
end

