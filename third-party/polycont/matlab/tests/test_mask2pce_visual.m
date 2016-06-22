
%% Iterative holes
mask = false(600);
mask(100:199,100:199) = true;
mask(200:400,200:400) = true;
mask(225:375,225:375) = false;
mask(250:350,250:350) = true;
mask(275:325,275:325) = false;
mask = [false(size(mask,1),100) mask];  % Uncenter to debug

% Get the polygon
pce = mask2pce(mask,3);

% Display
figure
imshow(mask)
hold on
plot_pce(pce);


%% Junctions that lead to non-closed curves
mask = false(600);
mask(100:199,100:199) = true;
mask(200:400,200:400) = true;
mask(401:500,401:500) = true;
mask(250:350,250:350) = false;
mask = [false(size(mask,1),100) mask];  % Uncenter to debug

% Get the polygon
pce = mask2pce(mask,3);

% Display
figure
imshow(mask)
hold on
plot_pce(pce);


%% Strange configuration of junctions
% Please observe that there are two possibilities for the
% interpretation of holes in this case. Both are correct
% in the sense of Jordan curves
mask = false(600);
mask(75:425,100:350)  = true;
mask(125:175,300:500) = true;
mask(125:175,200:350) = false;
mask(225:275,300:500) = true;
mask(225:275,200:350) = false;
mask(325:375,300:500) = true;
mask(325:375,200:350) = false;

% Get the polygon
pce = mask2pce(mask,3);

% Display
figure
imshow(mask)
hold on
plot_pce(pce);


