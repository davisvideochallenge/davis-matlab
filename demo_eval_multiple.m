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

% This sets up DAVIS
startup;

% Set the properties of DAVIS:
%  - 2017 is the year of the DAVIS edition
%  - 1 means multiple objects, 0 single object
%  - '480p' or 'Raw'
db_set_properties(2017, 1,'480p');

% Get the ids of all sequences
seq_ids = db_seqs('TrainVal');

% We try on the second sequence (bike-packing) that has two objects
seq = seq_ids{2};
    
% Get all frame ids for that sequence
frame_ids = db_frame_ids(seq);

% Let's get the image for frame 1
f_id = 1;
image  = db_read_image(seq, frame_ids{f_id});

% Read the object annotation
annot  = db_read_annot(seq, frame_ids{f_id});

% annot is a cell with the binary masks of each object
disp('annot = ')
disp(annot)

% In a realistic scenario, we would use db_read_result as follows:
% result = db_read_result(seq, frame_ids{f_id}, result_id); 

% Let's create a simple result from the ground truth for now
% It's also stored as a cell with binary masks
result = cell(1,length(annot));
for ii=1:length(annot)
    result{ii} = imerode(annot{ii},strel('disk',4));
end

% We can save it using db_write_result(result, res_file)
db_write_result(result, 'result.png')
% You can visualize the result directly opening the PNG

% And we can evaluate it
eval = eval_frame(result, {'J','F'}, annot);

% And the result has the two values for the two frames
disp('eval = ')
disp(eval)

% For the evalaution of the whole method, please use eval_result, as seen
% in experiments/global_table.m 






 

