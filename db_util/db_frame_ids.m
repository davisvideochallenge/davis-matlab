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
function frame_ids = db_frame_ids( seq_id )
    frame_ids = dir(fullfile(db_im_dir,seq_id,'*.jpg'));
    frame_ids = {frame_ids.name};
    
    for ii=1:length(frame_ids)
        frame_ids{ii} = strrep(frame_ids{ii},'.jpg','');
    end
    
    if isempty(frame_ids)
        error(['Error: Nothing found in ''' fullfile(db_im_dir,seq_id) '''. Did you download DAVIs and set the paths correctly?'])
    end
end

