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

% This sets - year, 2016 or 2017 
%           - single_or_multiple_objects: 0 - Single Objects, 1 - Multiple Objects
%           - im_size: '480p' or 'Full-Resolution, full resolution of the images (4k, 1080p, etc.)
db_set_properties(2017,1,'480p')

% Get the ids from a set gt_set
gt_set = 'TrainVal';
seq_ids = db_seqs(gt_set);

% Also possible to do it from a folder
% seq_ids = subdir('/path/to/my/results');

% Name of your method, this will create a folder with this name in 
results_id = 'your_method';

% Combine multiple masks for each object into the expected PNG
% You can do that manually using 'db_write_result(result, res_file)'
combine_multiple_pngs('/path/to/my/results',seq_ids,results_id)

% And now call eval result
eval = eval_result(result_id, {'F','J'}, gt_set);

% Display results
disp(['Mean J: ' num2str(mean(eval.J.mean))])
disp(['Mean F: ' num2str(mean(eval.F.mean))])