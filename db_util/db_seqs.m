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
function [db_seq_list, stab_seqs]= db_seqs(subset, quiet)

possible_sets = {'train-2016','val-2016','trainval-2016',...
                 'train-2017','val-2017','trainval-2017',...
                 'test-dev-2017'};

% Default value
if ~exist('subset','var')
    subset = 'test-dev-2017';
end
if ~exist('quiet','var')
    quiet = 0;
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

% Check old and multiple or new and single
if ~quiet
    if ismember(subset,{'train-2016','val-2016','trainval-2016'}) && (db_sing_mult_obj()==1)
        fprintf(2,'Warning! You are requesting a subset of 2016 but asking multiple-object ground truth. Are you sure that''s what you want?\n')
    end
    if ~ismember(subset,{'train-2016','val-2016','trainval-2016'}) && (db_sing_mult_obj()==0)
        fprintf(2,'Warning! You are requesting a subset newer than 2016 but asking single-object ground truth. Are you sure that''s what you want?\n')
    end
end

% Return the sets
if strcmp(subset,'train-2016')
     db_seq_list = {'bear'
                    'bmx-bumps'
                    'boat'
                    'breakdance-flare'
                    'bus'
                    'car-turn'
                    'dance-jump'
                    'dog-agility'
                    'drift-turn'
                    'elephant'
                    'flamingo'
                    'hike'
                    'hockey'
                    'horsejump-low'
                    'kite-walk'
                    'lucia'
                    'mallard-fly'
                    'mallard-water'
                    'motocross-bumps'
                    'motorbike'
                    'paragliding'
                    'rhino'
                    'rollerblade'
                    'scooter-gray'
                    'soccerball'
                    'stroller'
                    'surf'
                    'swing'
                    'tennis'
                    'train'};
elseif strcmp(subset,'val-2016')
     db_seq_list = {'blackswan'
                    'bmx-trees'
                    'breakdance'
                    'camel'
                    'car-roundabout'
                    'car-shadow'
                    'cows'
                    'dance-twirl'
                    'dog'
                    'drift-chicane'
                    'drift-straight'
                    'goat'
                    'horsejump-high'
                    'kite-surf'
                    'libby'
                    'motocross-jump'
                    'paragliding-launch'
                    'parkour'
                    'scooter-black'
                    'soapbox'};
elseif strcmp(subset,'trainval-2016')
    train2016 = db_seqs('train-2016',1);
    val2016 = db_seqs('val-2016',1);
    db_seq_list = sort([train2016;val2016(:)]);
elseif strcmp(subset,'train-2017')
    train2016 = db_seqs('train-2016',1);
    db_seq_list = sort([train2016;
                       {'boxing-fisheye'
                        'cat-girl'
                        'classic-car'
                        'color-run'
                        'crossing'
                        'dancing'
                        'disc-jockey'
                        'dog-gooses'
                        'dogs-scale'
                        'drone'
                        'kid-football'
                        'koala'
                        'lady-running'
                        'lindy-hop'
                        'longboard'
                        'miami-surf'
                        'night-race'
                        'planes-water'
                        'rallye'
                        'schoolgirls'
                        'scooter-board'
                        'sheep'
                        'skate-park'
                        'snowboard'
                        'stunt'
                        'tractor-sand'
                        'tuk-tuk'
                        'upside-down'
                        'varanus-cage'
                        'walking'}]);
elseif strcmp(subset,'val-2017')
    val2016 = db_seqs('val-2016',1);
    db_seq_list = sort([val2016;
                       {'bike-packing'
                        'dogs-jump'
                        'gold-fish'
                        'india'
                        'judo'
                        'lab-coat'
                        'loading'
                        'mbike-trick'
                        'pigs'
                        'shooting'}]);
elseif strcmp(subset,'trainval-2017')
    train2017 = db_seqs('train-2017',1);
    val2017 = db_seqs('val-2017',1);
    db_seq_list = sort([train2017;val2017(:)]);
elseif strcmp(subset,'test-dev-2017')
    db_seq_list =  {'aerobatics'
                    'car-race'
                    'carousel'
                    'cats-car'
                    'chamaleon'
                    'deer'
                    'girl-dog'
                    'golf'
                    'guitar-violin'
                    'gym'
                    'helicopter'
                    'horsejump-stick'
                    'hoverboard'
                    'lock'
                    'man-bike'
                    'monkeys-trees'
                    'mtb-race'
                    'orchid'
                    'people-sunset'
                    'planes-crossing'
                    'rollercoaster'
                    'salsa'
                    'seasnake'
                    'skate-jump'
                    'slackline'
                    'subway'
                    'tandem'
                    'telemarkt'
                    'tennis-vest'
                    'tractor'};
end


% Now return the stable sequences if asked. We remove the unstable from the
% set requested
if nargout>1
    % List of sequences where stability is not computed (occlusions, etc.)
    unstab_seqs = {'lucia', 'rollerblade', 'mallard-fly', 'bmx-bumps', 'goat', 'scooter-gray', 'bmx-trees', 'dance-twirl', 'motocross-jump', 'soccerball', 'breakdance', 'dog', 'horsejump-high', 'motorbike', 'breakdance-flare', 'dog-agility', 'horsejump-low', 'paragliding', 'drift-chicane', 'swing','parkour','tennis','libby'};
    
    % Find the stable ones
    stab_seqs = setdiff(1:length(db_seq_list),find(ismember(db_seq_list,unstab_seqs)));
end
  

end
