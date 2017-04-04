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
function [db_seq_list, stab_seqs]= db_seqs(subset)

possible_sets = {'Train','Val','TrainVal'};
if db_year()==2017
    possible_sets{end+1} = 'Test-Dev';
end

% Default value
if ~exist('subset','var')
    subset = 'Test-Dev';
end

% Check it's a possible set
if ~ismember(subset,possible_sets)
    fprintf(2,'The subset requested in ''db_seqs'' is not available.\nPossible values are:\n ')
    for ii=1:length(possible_sets)-1
        fprintf(2,'''%s'', ',possible_sets{ii})
    end
    fprintf(2,'%s.\n',possible_sets{end});
    db_seq_list = [];
    stab_seqs = [];
    return 
end

% Return the sets
if strcmp(subset,'Train-Val')
    train = db_seqs('Train');
    val = db_seqs('Val');
    db_seq_list = sort([train;val(:)]);
else
    db_seq_list = read_list_from_file( subset );
end

% Now return the stable sequences if asked. We remove the unstable from the
% set requested
if nargout>1
    % TODO
    fprintf(2,'Warning: You requested the stable sequences but they are not updated\n')
    
    % List of sequences where stability is not computed (occlusions, etc.)
    unstab_seqs = {'lucia', 'rollerblade', 'mallard-fly', 'bmx-bumps', 'goat', 'scooter-gray', 'bmx-trees', 'dance-twirl', 'motocross-jump', 'soccerball', 'breakdance', 'dog', 'horsejump-high', 'motorbike', 'breakdance-flare', 'dog-agility', 'horsejump-low', 'paragliding', 'drift-chicane', 'swing','parkour','tennis','libby'};
    
    % Find the stable ones
    stab_seqs = setdiff(1:length(db_seq_list),find(ismember(db_seq_list,unstab_seqs)));
end
  

end
