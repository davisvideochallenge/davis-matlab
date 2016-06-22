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
% Show table of which attributes each sequence has
% ------------------------------------------------------------------------

% Get the parameters
experiments_params();

% Get the attributes
db = db_attributes();

% Sort them alphabetically
attr_names = sort(db.attr_names);

% Show header
clc
disp('% ------ Matlab-generated LaTeX code ------')
fprintf('%s',strpad('Sequence',20,'post',' '))
for ii=1:length(attr_names)
    fprintf('& %s',strpad(attr_names{ii},8,'post',' '))
end
fprintf('\\\\\n\\midrule\n')

% Show attributes for each sequence
for jj=1:length(db.seq_names)
    fprintf('%s',strpad(db.seq_names{jj},20,'post',' '))
    for ii=1:length(attr_names)
        if ismember(attr_names{ii},db.seq_attr(db.seq_names{jj}))
            fprintf('& %s',strpad('\cmark',8,'post',' '))
        else
            fprintf('& %s',strpad('',8,'post',' '))
        end
    end
    fprintf('\\\\\n')
end

disp('% ------ End of Matlab-generated LaTeX code ------')
