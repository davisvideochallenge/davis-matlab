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
function image = db_read_image(seq_id, frame_id)
    im_file = fullfile(db_im_dir, seq_id, [frame_id '.jpg']);
    if ~exist(im_file,'file')
        error(['Error: ''' im_file ''' not found, have you downloaded the DAVIS database from the project website?'])
    end
    image = imread(im_file);
end