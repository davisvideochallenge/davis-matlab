experiments_params();
gt_set = 'val';

res_folder = '.';

for ii=1:length(techniques)
    res_file = fullfile(res_folder,[strrep(techniques{ii},'-',''), '_davis.json']);
    davis2json(techniques{ii},res_file,gt_set);
end

% REMEMBER TO SET THE FILES TO READABLE BY ALL USERS