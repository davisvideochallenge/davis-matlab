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
function annot = db_read_annot(seq_id, frame_id)
    annot_file = fullfile(db_annot_dir, seq_id, [frame_id '.png']);
    if ~exist(annot_file,'file')
        error(['Error: ''' annot_file ''' not found, have you downloaded the DAVIS database from the project website?'])
    end
    im_annot = imread(annot_file);
    assert(size(im_annot,3)==1)
    
    n_objs = max(im_annot(:));
    
    % If single object
    if db_sing_mult_obj==0
        n_objs = 1;
        im_annot = (im_annot>0);
    end
    
    % Transform it into a cell of masks
    if db_sing_mult_obj==1
        annot = cell(n_objs,1);
        for ii=1:n_objs
            annot{ii} = (im_annot==ii);
        end
    else
        annot = im_annot;
    end
        
end