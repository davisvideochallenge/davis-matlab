% ------------------------------------------------------------------------ 
%  Copyright (C)
%  ETHZ - Computer Vision Lab
% 
%  Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
%  September 2015
% ------------------------------------------------------------------------ 
% This file is part of the BOP package presented in:
%    Pont-Tuset J, Van Gool, Luc,
%    "Boosting Object Proposals: From Pascal to COCO"
%    International Conference on Computer Vision (ICCV) 2015.
% Please consider citing the paper if you use this code.
% ------------------------------------------------------------------------
function ids = read_list_from_file( gt_set )
    index_file = fullfile(db_root_dir,'ImageSets',num2str(db_year()),[gt_set '.txt']);
    if ~exist(index_file,'file')
        error(['File ''' index_file ''' not found... This should not happen, contact the authors'])
    end
    fileID = fopen(index_file);
    ids = textscan(fileID, '%s');
    ids = ids{1};
    fclose(fileID);
end

