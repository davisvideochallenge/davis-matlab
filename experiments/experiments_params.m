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
techniques = {'onavos','osvos','cut','sfls','sflu',... % These are only on val
              'msk','vpn','ofl',...  
              'ctn','lmp','bvs','fcp','jmp','hvs','sea','tsp',...
              'arp','lvo','fseg','nlc','cvos','trc','msg',...
              'key','sal','fst',...
              'mcg','sf-lab','sf-mot'
              };

% Output folder to save files
paper_data = '~/tmp';       
