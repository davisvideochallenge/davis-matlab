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
function db_write_result(result, res_file)
    
    im_res = zeros(size(result{1}));
    for ii=1:length(result)
        if sum(im_res(result{ii}(:)>0))>0
            fprintf(2,'Warning: The masks you are writing to file overlap, so there will be some loss in writing to PNG\n');
        end
        im_res(result{ii}>0) = ii;
    end
    imwrite(uint8(im_res), pascal_colormap(), res_file);

end