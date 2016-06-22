% plot_pce( pce )
%------------------------------------------------------------------------
% Plot the polygon represented by poly
% PARAMS IN:
%   pce          : Polygonal representation of the contour.
%------------------------------------------------------------------------
% Copyright (C)
% Jordi Pont-Tuset <jponttuset@vision.ee.ethz.ch>
% July 2015
%------------------------------------------------------------------------
function plot_pce( pce )

% Sweep all 'pieces'
for jj=1:length(pce.paths)
    % Plot holes in a different colour
    if pce.paths(jj).is_hole
        plot(pce.paths(jj).contour_coords(:,2)+0.5, pce.paths(jj).contour_coords(:,1)+0.5,'g-o')
    else
        plot(pce.paths(jj).contour_coords(:,2)+0.5, pce.paths(jj).contour_coords(:,1)+0.5,'r-o')
    end
end

end

