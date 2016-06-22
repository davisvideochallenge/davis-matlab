
%% Two simple masks
% Create mask 1
mask1 = false(600);
mask1(100:400,100:400) = true;
mask1 = [false(size(mask1,1),100) mask1];  % Uncenter to debug

% Create mask 2
mask2 = false(600);
mask2(200:500,200:500) = true;
mask2 = [false(size(mask2,1),100) mask2];  % Uncenter to debug
mask2(50:150,50:150) = true;               % Add a second 'blob'

% Show masks
% imshow(mask1+mask2,[]);

% Get polygons
pce1 = mask2pce(mask1,3);
pce2 = mask2pce(mask2,3);

% Get the intersection between polygons and area
 int_pces = pce_intersection(pce1, pce2);
area_pces = pce_area(pce1);

% Do the same between masks (we know this works)
 int_masks = sum(mask1(:).*mask2(:));
area_masks = sum(mask1(:));

% Are they the same?
assert(int_pces==int_masks);
assert(area_pces==area_masks);

%% Check that holes work
mask1 = false(600,400);
mask1( 50:550, 50:350) = true;
mask1(100:500,100:300) = false;

mask2 = false(600,400);
mask2(100:500,100:300) = true;

% Get polygons
pce1 = mask2pce(mask1,3);
pce2 = mask2pce(mask2,3);

% Check that intersection is zero
assert(pce_intersection(pce1, pce2) == 0);

%% A single pixel
mask1 = false(600,400);
mask1(10,10) = true;
pce1 = mask2pce(mask1,3);
assert(isempty(pce1.paths))



