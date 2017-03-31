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
function result = db_attributes()

% TODO
fprintf(2,'Warning: You requested the attributes but they are not updated\n')
    
att_file = fullfile(db_matlab_root_dir,'db_util','private','attributes.txt');

fid = fopen(att_file,'r');

% Get the attribute names in the first line
tline = fgets(fid);
attr_names = strsplit(tline);
result.attr_names = attr_names(2:end);

% Get the attribute values for all sequences
ii=1;
tline = fgets(fid);
while ischar(tline)
    parts = strsplit(tline);
    result.seq_names{ii} = parts{1};
    seq_attrs{ii} = result.attr_names(ismember(parts(2:end),'True')); %#ok<AGROW>
    tline = fgets(fid);
    ii = ii+1;
end
fclose(fid);

% Put it in a Map for ease of use
result.seq_attr = containers.Map(result.seq_names, seq_attrs);

% Build the inverse LUT (which sequences have each attribute)
result.attr_seq = containers.Map(result.attr_names, cell(1,length(result.attr_names)));
for ii=1:length(result.seq_names)
    curr_attr = result.seq_attr(result.seq_names{ii});
    for jj=1:length(curr_attr)
        tmp = result.attr_seq(curr_attr{jj});
        tmp{end+1} = result.seq_names{ii}; %#ok<AGROW>
        result.attr_seq(curr_attr{jj}) = tmp;
    end
end

end
