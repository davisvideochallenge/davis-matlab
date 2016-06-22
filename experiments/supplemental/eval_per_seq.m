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
% All techniques on all sequences
% ------------------------------------------------------------------------

% Get the parameters
experiments_params();
db = db_attributes();

%% Evaluate them or load pre-computed evaluation
F = cell(1,length(techniques));
J = cell(1,length(techniques));
T = cell(1,length(techniques));
for ii=1:length(techniques)
    eval = eval_result(techniques{ii},{'F','J','T'});
    F{ii} = eval.F;
    J{ii} = eval.J;
    T{ii} = eval.T;
end
eval = eval_result('gt','T');
Tgt  = eval.T;

%% Put them in a single matrix
mF = zeros(length(F{1}.mean),length(techniques));
mJ = zeros(length(F{1}.mean),length(techniques));
mT = zeros(length(F{1}.mean),length(techniques));

for ii=1:length(techniques)
    mF(:,ii) = F{ii}.mean;
    mJ(:,ii) = J{ii}.mean;
    mT(:,ii) = T{ii}.mean;
end


%% Show table

% Choose measure and according max_min
sel_meas = 1; % 1, 2, or 3
if sel_meas==1
    meas = mJ;
    max_min = 1;
    seq_names = db.seq_names;
elseif sel_meas==2
    meas = mF;
    max_min = 1;
    seq_names = db.seq_names;
else
    meas = mT(stab_seqs,:);
    max_min = 0;
    seq_names = db.seq_names(stab_seqs);
end

% Define the groups of techniques to get the maximum values in bold
max_groups = [1 1 1   2 2 2 2 2 2 2   3 3 3 3 3];

% Show header
clc
disp('% ------ Matlab-generated LaTeX code ------')
fprintf('%s',strpad('Sequence',20,'post',' '))
for ii=1:length(techniques_paper)
    fprintf('& %s',strpad(techniques_paper{ii},8,'post',' '))
end
fprintf('\\\\\n\\midrule\n')

% Show attributes for each sequence
for kk=1:length(seq_names)
    % Get the maximum on each of the groups
    n_groups = length(unique(max_groups));
    max_ids = zeros(1,n_groups);
    for jj=1:n_groups
        if max_min
            tmp = meas(kk,:); tmp(max_groups~=jj) = 0;
            [~, max_ids(jj)] = max(tmp);
        else
            tmp = meas(kk,:); tmp(max_groups~=jj) = 1e10;
            [~, max_ids(jj)] = min(tmp);
        end
    end

    % Display
    fprintf('%s',strpad(seq_names{kk},20,'post',' '))
    for ii=1:length(techniques_paper)
        if ismember(ii,max_ids)
            fprintf('& \\bf %s',strpad(sprintf('%0.3f',meas(kk,ii)),8,'post',' '))
        else
            fprintf('&     %s',strpad(sprintf('%0.3f',meas(kk,ii)),8,'post',' '))
        end
    end
    fprintf('\\\\\n')
end


% Get the maximum on each of the groups
allM = mean(meas);
n_groups = length(unique(max_groups));
max_ids = zeros(1,n_groups);
for jj=1:n_groups
    if max_min
        tmp = allM; tmp(max_groups~=jj) = 0;
        [~, max_ids(jj)] = max(tmp);
    else
        tmp = allM; tmp(max_groups~=jj) = 1e10;
        [~, max_ids(jj)] = min(tmp);
    end
end

% Show mean
fprintf('\\midrule\n')
fprintf('%s',strpad('Mean',20,'post',' '))
for ii=1:length(techniques_paper)
    if ismember(ii,max_ids)
        fprintf('& \\bf %s',strpad(sprintf('%0.3f',allM(ii)),8,'post',' '))
    else
        fprintf('&     %s',strpad(sprintf('%0.3f',allM(ii)),8,'post',' '))
    end
end
fprintf('\\\\\n')

disp('% ------ End of Matlab-generated LaTeX code ------')
