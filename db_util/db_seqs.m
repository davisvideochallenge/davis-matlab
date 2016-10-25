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
function db_seq_list = db_seqs(subset)

if ~exist('subset','var')
    subset = 'all';
end

if strcmp(subset,'all')
     db_seq_list = {'bear'
                    'car-shadow'
                    'elephant'
                    'lucia'
                    'rollerblade'
                    'blackswan'
                    'car-turn'
                    'flamingo'
                    'mallard-fly'
                    'scooter-black'
                    'bmx-bumps'
                    'cows'
                    'goat'
                    'mallard-water'
                    'scooter-gray'
                    'bmx-trees'
                    'dance-jump'
                    'hike'
                    'motocross-bumps'
                    'soapbox'
                    'boat'
                    'dance-twirl'
                    'hockey'
                    'motocross-jump'
                    'soccerball'
                    'breakdance'
                    'dog'
                    'horsejump-high'
                    'motorbike'
                    'stroller'
                    'breakdance-flare'
                    'dog-agility'
                    'horsejump-low'
                    'paragliding'
                    'surf'
                    'bus'
                    'drift-chicane'
                    'kite-surf'
                    'paragliding-launch'
                    'swing'
                    'camel'
                    'drift-straight'
                    'kite-walk'
                    'parkour'
                    'tennis'
                    'car-roundabout'
                    'drift-turn'
                    'libby'
                    'rhino'
                    'train'};
elseif strcmp(subset,'train')
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
elseif strcmp(subset,'val'),
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
end

end
