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

% Add paths
addpath(db_matlab_root_dir);
addpath(fullfile(db_matlab_root_dir,'db_util'));
addpath(genpath(fullfile(db_matlab_root_dir,'experiments')));
addpath(fullfile(db_matlab_root_dir,'measures'));
addpath(fullfile(db_matlab_root_dir,'third-party','polycont','matlab'))
addpath(fullfile(db_matlab_root_dir,'third-party','jsonlab'))

% Check compiled files
needed_files = {'measures/private/mex_match_dijkstra'};
for ii=1:length(needed_files)
    if ~exist(fullfile(db_matlab_root_dir,[needed_files{ii} '.' mexext]),'file')
        error(['The needed function (' needed_files{ii} ') not found. Have you built the package properly?'])
    end
end

% Clear
clear needed_files;
clear ii;

% Display message
disp('DAVIS Matlab Packages started correctly. Enjoy!')