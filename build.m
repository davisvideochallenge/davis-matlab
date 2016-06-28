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
mex measures/private/mex_match_dijkstra.cpp -I/opt/local/include/ -Ithird-party -outdir measures/private/

cd third-party
run matlab_build.m
cd ..

