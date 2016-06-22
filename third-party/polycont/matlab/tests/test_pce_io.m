

%% A simple mask with two blobs

% Create mask
mask0 = false(600,500);
mask0(100:400,100:200) = true;
mask0(100:400,300:350) = true;

% Get polygon
pce1 = mask2pce(mask0,3);

% Get the mask back
mask1 = pce2mask(pce1);

% Write to file
pce_write(pce1, 'matlab/tests/test_io.pce');

% Read polygon
pce2 = pce_read('matlab/tests/test_io.pce');

% Transform to mask
mask2 = pce2mask(pce2);

% Check they are the same
assert(isequal(mask0, mask1))
assert(isequal(mask1, mask2))
assert(isequal(pce1, pce2))



%% A mask with a hole

% Create mask
mask0 = false(600,400);
mask0( 50:550, 50:350) = true;
mask0(100:500,100:300) = false;

% Get polygon
pce1 = mask2pce(mask0,3);

% Get the mask back
mask1 = pce2mask(pce1);

% Write to file
pce_write(pce1, 'matlab/tests/test_io.pce');

% Read polygon
pce2 = pce_read('matlab/tests/test_io.pce');

% Transform to mask
mask2 = pce2mask(pce2);

% Check they are the same
assert(isequal(mask0, mask1))
assert(isequal(mask1, mask2))
assert(isequal(pce1, pce2))


