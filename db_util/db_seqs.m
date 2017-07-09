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
function [db_seq_list, stab_obj]= db_seqs(subset)

possible_sets = {'train','val','trainval'};
if db_year()==2017
    possible_sets{end+1} = 'test-dev';
    possible_sets{end+1} = 'test-challenge';
end

% Default value
if ~exist('subset','var')
    subset = 'test-dev';
end

% Check it's a possible set
if ~ismember(subset,possible_sets)
    fprintf(2,'The subset requested in ''db_seqs'' is not available.\nPossible values are:\n ')
    for ii=1:length(possible_sets)-1
        fprintf(2,'''%s'', ',possible_sets{ii})
    end
    fprintf(2,'''%s''.\n',possible_sets{end});
    db_seq_list = [];
    stab_obj = [];
    return 
end

% Return the sets
if strcmp(subset,'trainval')
    train = db_seqs('train');
    val = db_seqs('val');
    db_seq_list = sort([train;val(:)]);
else
    db_seq_list = read_list_from_file( subset );
end

% Now return the stable objects (sequences) if asked. We remove the unstable from the set requested
if nargout>1
    if db_sing_mult_obj()==1        
        % Create list of all objects
        all_obj = {};
        for ii=1:length(db_seq_list)
            n_obj = length(db_read_annot(db_seq_list{ii},'00000'));
            for jj=1:n_obj
                all_obj{end+1} = [db_seq_list{ii} '-' num2str(jj)]; %#ok<AGROW>
            end
        end
        
        % List of unstable objects
        unstab_obj = {'bike-packing-1', 'bike-packing-2', 'bmx-bumps-1', 'bmx-bumps-2', 'bmx-trees-1', 'bmx-trees-2', 'boxing-fisheye-1', 'boxing-fisheye-2', 'boxing-fisheye-3', 'breakdance-1', 'breakdance-flare-1', 'cat-girl-1', 'cat-girl-2', 'classic-car-2', 'color-run-1', 'color-run-2', 'color-run-3', 'crossing-1', 'crossing-2', 'crossing-3', 'dance-twirl-1', 'dancing-1', 'dancing-2', 'dancing-3', 'disc-jockey-1', 'disc-jockey-2', 'disc-jockey-3', 'dog-1', 'dog-agility-1', 'dog-gooses-1', 'dog-gooses-2', 'dog-gooses-3', 'dog-gooses-4', 'dog-gooses-5', 'dogs-jump-1', 'dogs-jump-2', 'dogs-jump-3', 'dogs-scale-1', 'dogs-scale-2', 'dogs-scale-3', 'dogs-scale-4', 'drift-chicane-1', 'drone-1', 'drone-2', 'drone-3', 'drone-4', 'drone-5', 'goat-1', 'gold-fish-1', 'gold-fish-2', 'gold-fish-5', 'hockey-2', 'hockey-3', 'horsejump-high-1', 'horsejump-high-2', 'horsejump-low-1', 'horsejump-low-2', 'india-1', 'india-2', 'india-3', 'judo-2', 'kid-football-1', 'kid-football-2', 'kite-surf-1', 'kite-surf-2', 'kite-surf-3', 'kite-walk-1', 'kite-walk-2', 'kite-walk-3', 'koala-1', 'lab-coat-1', 'lab-coat-2', 'lady-running-2', 'libby-1', 'lindy-hop-1', 'lindy-hop-2', 'lindy-hop-3', 'lindy-hop-4', 'lindy-hop-5', 'lindy-hop-6', 'lindy-hop-7', 'lindy-hop-8', 'loading-2', 'loading-3', 'longboard-2', 'longboard-3', 'longboard-4', 'longboard-5', 'lucia-1', 'mallard-fly-1', 'mbike-trick-1', 'miami-surf-1', 'miami-surf-2', 'miami-surf-3', 'miami-surf-4', 'miami-surf-5', 'miami-surf-6', 'motocross-bumps-2', 'motocross-jump-1', 'motocross-jump-2', 'motorbike-1', 'motorbike-2', 'motorbike-3', 'night-race-1', 'paragliding-1', 'paragliding-launch-1', 'paragliding-launch-2', 'paragliding-launch-3', 'parkour-1', 'pigs-2', 'planes-water-2', 'rallye-1', 'rollerblade-1', 'schoolgirls-1', 'schoolgirls-2', 'schoolgirls-3', 'schoolgirls-4', 'schoolgirls-5', 'schoolgirls-6', 'schoolgirls-7', 'scooter-board-1', 'scooter-board-2', 'scooter-gray-1', 'scooter-gray-2', 'sheep-4', 'sheep-5', 'shooting-1', 'shooting-2', 'skate-park-1', 'skate-park-2', 'snowboard-1', 'snowboard-2', 'soapbox-2', 'soapbox-3', 'soccerball-1', 'stunt-1', 'stunt-2', 'surf-1', 'surf-2', 'surf-3', 'swing-1', 'swing-2', 'swing-3', 'tennis-1', 'tennis-2', 'tractor-sand-1', 'tractor-sand-2', 'tractor-sand-3', 'tuk-tuk-1', 'tuk-tuk-2', 'tuk-tuk-3', 'upside-down-1', 'upside-down-2', 'varanus-cage-1', 'walking-2',...
                      'bike-trial-2', 'boxing-2', 'boxing-3', 'choreography-1', 'choreography-3', 'choreography-4', 'choreography-6', 'choreography-7', 'dog-control-1', 'dog-control-2', 'dolphins-6', 'e-bike-1', 'e-bike-2', 'grass-chopper-2', 'grass-chopper-3', 'grass-chopper-4', 'hurdles-1', 'hurdles-2', 'hurdles-3', 'juggle-1', 'juggle-4', 'kids-turning-2', 'lions-1', 'monkeys-2', 'ocean-birds-1', 'pole-vault-1', 'pole-vault-2', 'running-2', 'selfie-4', 'skydive-1', 'skydive-2', 'speed-skating-2', 'speed-skating-3', 'swing-boy-1', 'tackle-1', 'tackle-2', 'tackle-3', 'vietnam-4', 'vietnam-5', 'vietnam-6', 'vietnam-7', 'wings-turn-3'};
        
        % Find the stable ones
        stab_obj = false(length(all_obj),1);
        stab_obj(setdiff(1:length(all_obj),find(ismember(all_obj,unstab_obj)))) = true;
    else
    
        % List of sequences where stability is not computed (occlusions, etc.)
        unstab_seqs = {'bike-packing', 'bmx-bumps', 'bmx-trees', 'boxing-fisheye', 'breakdance', 'breakdance-flare', 'cat-girl', 'classic-car', 'color-run', 'crossing', 'dance-twirl', 'dancing', 'disc-jockey', 'dog', 'dog-agility', 'dog-gooses', 'dogs-jump', 'dogs-scale', 'drift-chicane', 'drone', 'goat', 'gold-fish', 'horsejump-high', 'horsejump-low', 'india', 'judo', 'kid-football', 'koala', 'lab-coat', 'lady-running', 'libby', 'lindy-hop', 'loading', 'longboard', 'lucia', 'mallard-fly', 'mbike-trick', 'miami-surf', 'motocross-jump', 'motorbike', 'night-race', 'paragliding', 'parkour', 'pigs', 'planes-water', 'rallye', 'rollerblade', 'schoolgirls', 'scooter-board', 'scooter-gray', 'sheep', 'shooting', 'skate-park', 'snowboard', 'soccerball', 'stunt', 'swing', 'tennis', 'tractor-sand', 'tuk-tuk', 'upside-down', 'varanus-cage', 'walking'};

        % Find the stable ones
        stab_obj = false(length(db_seq_list),1);
        stab_obj(setdiff(1:length(db_seq_list),find(ismember(db_seq_list,unstab_seqs)))) = true;
    end 
end
  

end
