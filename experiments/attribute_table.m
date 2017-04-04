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
% Reproduce Table 3 in the paper
% ------------------------------------------------------------------------

% Get the parameters
experiments_params();

% Set of sequences
gt_set = 'TrainVal';

%% Evaluate them or load pre-computed evaluation
% Remove the preprocessing techniques
non_prep_tech = techniques(4:end);
non_prep_paper = techniques_paper(4:end);

J = cell(1,length(non_prep_tech));
for ii=1:length(non_prep_tech)
    eval = eval_result(non_prep_tech{ii},'J',gt_set);
    J{ii} = eval.J;
end

% Read the attributes for each sequence
db = db_attributes();


%% Get the evaluation per attribute
% Put evaluation in a single matrix
all_J = zeros(length(J{1}.mean),length(non_prep_tech));
for ii=1:length(non_prep_tech)
    all_J(:,ii)   = J{ii}.mean;
end

all_attr      = zeros(length(db.attr_names),length(non_prep_tech));
all_atrr_diff = zeros(length(db.attr_names),length(non_prep_tech));
for ii=1:length(db.attr_names)
   sel_seq = ismember(db_seqs(gt_set), db.attr_seq(db.attr_names{ii}));
   
   all_attr(ii,:)      = mean(all_J(sel_seq,:));
   all_atrr_diff(ii,:) = mean(all_J(~sel_seq,:))-all_attr(ii,:);
end


%% Display evaluation table
which_att = [14 7 4 8 10];
% which_att = 1:15;

clc
disp(repmat('=',[1,212]))
fprintf('\t');
for ii=1:length(non_prep_tech), fprintf('%s\t\t',non_prep_paper{ii}), end; fprintf('\n');
disp(repmat('-',[1,212]))
for ii=1:length(which_att)
    fprintf('%s\t',db.attr_names{which_att(ii)});
    for jj=1:length(non_prep_tech)
        fprintf('%0.2f (%0.2f)\t',all_attr(which_att(ii),jj),all_atrr_diff(which_att(ii),jj)); 
    end
    fprintf('\n');
end
disp(repmat('=',[1,212]))


%% Display evaluation table (in LaTeX)
which_att = [14 7 4 8 10];
% which_att = 1:15;

% Define the groups of techniques to get the maximum values in bold
max_groups = [1 1 1 1 1 1 1   2 2 2 2 2 2];

clc;
disp('% ------ Matlab-generated LaTeX code ------')

for ii=1:length(which_att)
    fprintf('%s\t',db.attr_names{which_att(ii)});
    
    % Get the maximum on each of the groups
    n_groups = length(unique(max_groups));
    max_ids = zeros(1,n_groups);
    for jj=1:n_groups
        tmp = all_attr(which_att(ii),:); tmp(max_groups~=jj) = 0;
        [~, max_ids(jj)] = max(tmp);
    end
    
    % Sweep all columns
    assert(length(non_prep_tech)==length(max_groups));
    for jj=1:length(non_prep_tech)
        if all_atrr_diff(which_att(ii),jj)<0, sp = ''; else sp = '+'; end
        if ismember(jj,max_ids), bf = '\bf'; else bf = '   '; end

        fprintf('&%s %0.2f \\emph{\\scriptsize{%s%0.2f}}\t',bf, all_attr(which_att(ii),jj),sp,all_atrr_diff(which_att(ii),jj));         
    end
    fprintf('\\\\\n');
end

disp('% ------ End of Matlab-generated LaTeX code ------')
