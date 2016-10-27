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
% This file defines the parameters of the experiments
% ------------------------------------------------------------------------

% List of techniques compared
techniques = {'mcg','sf-lab','sf-mot',...
              'nlc','cvos','trc','msg',...
              'key','sal','fst',...
              'tsp','sea','hvs','jmp','fcp','bvs'};
          
% Names to be shown on the tables
techniques_paper = {'MCG','SF-LAB','SF-MOT',...
                    'NLC','CVOS','TRC','MSG',...
                    'KEY','SAL','FST',...
                    'TSP','SEA','HVS','JMP','FCP','BVS'};

% Output folder to save files
paper_data = '~/tmp';
                
% List of 27 sequences where stability is computed (no occlusions, etc.)
stab_seqs = setdiff(1:50,[4 5 9 11 13 15 16 22 24 25 26 27 28 29 31 32 33 34 37 40 44 45 48]);         
