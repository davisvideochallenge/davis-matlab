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
% Rebuild the DAVIS package and dependencies
% ------------------------------------------------------------------------

if (strcmp(computer(),'PCWIN64') || strcmp(computer(),'PCWIN32'))
    %  Change the path to Boost libraries if necessary
    mex measures/private/mex_match_dijkstra.cpp -I'C:\Program Files\boost_1_55_0' -Ithird-party -outdir measures/private/; 
else
    mex measures/private/mex_match_dijkstra.cpp -I/opt/local/include/  -Ithird-party -outdir measures/private/
end

% Build third party
cd third-party
run matlab_build.m
cd ..

