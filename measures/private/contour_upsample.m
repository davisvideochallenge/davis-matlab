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
function [up_cont, original_marker] = contour_upsample(cont, cont_th)
    cont = [cont; cont(1,:)];
    v = diff(cont);
    nv = arrayfun(@(idx) norm(v(idx,:)), 1:size(v,1))';
    
    up_cont = [];
    original_marker = [];
    for ii=1:length(nv)
        up_cont = [up_cont; cont(ii,:)]; %#ok<AGROW>
        original_marker = [original_marker; 1]; %#ok<AGROW>
        
        % If segment is too long, resample in between
        if nv(ii)>cont_th
            n_segm = ceil(nv(ii)/cont_th);
            curr_point = up_cont(end,:);
            vec = v(ii,:)/n_segm;
            for jj=1:n_segm-1
                curr_point = curr_point + vec;
                up_cont = [up_cont; curr_point]; %#ok<AGROW>
                original_marker = [original_marker; 0]; %#ok<AGROW>
            end
        end
    end
    
    original_marker = logical(original_marker);
end