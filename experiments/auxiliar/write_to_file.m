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
function write_to_file(filename, headers, data )

% Create header and pattern string
assert(length(headers)==size(data,2))
str_pattern = '%f';
str_header  = headers{1};
for ii=2:length(headers)
    str_pattern = [str_pattern '\t%f']; %#ok<AGROW>
    str_header  = [str_header '\t' headers{ii}]; %#ok<AGROW>
end
str_pattern = [str_pattern '\n'];
str_header = [str_header '\n'];

% Write to file
fid = fopen(filename,'w');
fprintf(fid, str_header);
fprintf(fid, str_pattern, data');
fclose(fid);


end

