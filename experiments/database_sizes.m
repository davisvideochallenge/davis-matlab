% ------------------------------------------------------------------------ 
% Sergi Caelles, Jordi Pont-Tuset
% April 2017
% ------------------------------------------------------------------------ 
% This file is part of the DAVIS package presented in:
%     @article{Pont-Tuset_arXiv_2017,
%       author    = {Jordi Pont-Tuset and Federico Perazzi and Sergi Caelles and
%                    Pablo Arbel\'aez and Alexander Sorkine-Hornung and Luc {Van Gool}},
%       title     = {The 2017 DAVIS Challenge on Video Object Segmentation},
%       journal   = {arXiv:1704.00675},
%       year      = {2017}
%     }
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------

db_set_properties(2017, 1, '480p');

sets = {'train','val','test-dev'};

for ii=1:length(sets)
    seqs = db_seqs(sets{ii});
    n_frames = 0;
    n_objs   = 0;
    for kk=1:length(seqs)
        frames = db_frame_ids(seqs{kk});
        n_frames = n_frames + length(frames); 
        n_objs = n_objs + length(db_read_annot(seqs{kk},frames{1}));    
    end
    disp(['Set: ' sets{ii} ', Frames: ' num2str(n_frames) ', Objects: ' num2str(n_objs)])
end
