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
% Combine results from multiple binary (or probability maps) masks into
% a single PNG as expected by DAVIS. 
%
% Folder structure for the input results is expected as:
%  separate_masks_dir/seq_name/obj_id/frames
% For example, bike-packing, which has two objects:
%  separate_masks_dir/bike-packing/1/000xx.png
%  separate_masks_dir/bike-packing/2/000xx.png
% ------------------------------------------------------------------------

function combine_multiple_pngs(separate_masks_dir,seq_ids,result_id)

res_dir = fullfile(db_results_dir, result_id);
if ~exist(res_dir,'dir')
    mkdir(res_dir)
end

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
        
        % Read the result, each object in one directory
        obj_ids = sort(subdir(fullfile(separate_masks_dir,seq_ids{s_id})));
        if(length(obj_ids)~=str2double(obj_ids{end}))
            fprintf(2,'Object IDs (subfolders) are not consecutive 1..N\n')
        end
        
        % Allocate and read all masks
        result = cell(1,length(obj_ids));
        for ii=1:length(obj_ids)
            result{ii} = imread(fullfile(separate_masks_dir,seq_ids{s_id},num2str(ii),[frame_ids{f_id} '.png']));
        end
        
        % Put in a single matrix to binarize
        res_mat = zeros(size(result{1},1),size(result{1},2),length(obj_ids));
        for ii=1:length(obj_ids)
            res_mat(:,:,ii) = result{ii};
        end
        
        % And find the maximum at each pixel
        [~,marker] = max(res_mat,[],3);
        for ii=1:length(obj_ids)
            result{ii} = (marker==ii)&(result{ii}>(max(result{ii})/2.));
        end
        
        % Write a result
        db_write_result(result,fullfile(seq_dir,[frame_ids{f_id} '.png']))
    end
    fprintf('\n');
end







