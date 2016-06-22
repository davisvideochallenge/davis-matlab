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
% Plots per-sequence in the supplemental
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
stdF = zeros(length(F{1}.mean),length(techniques));
mJ = zeros(length(F{1}.mean),length(techniques));
stdJ = zeros(length(F{1}.mean),length(techniques));
for ii=1:length(techniques)
    mF(:,ii) = F{ii}.mean;
    stdF(:,ii) = F{ii}.std;
    mJ(:,ii) = J{ii}.mean;
    stdJ(:,ii) = J{ii}.std;
end

%% Sort sequences by 'difficulty'
seq_m = mean(mJ,2);
[~,seq_order] = sort(seq_m,'ascend');

%% Show header
disp('% ------ Matlab-generated LaTeX code ------')
fprintf('xticklabels={');
for ii=1:length(seq_order)
    if ii==length(seq_order)
        fprintf('%s},\n',db.seq_names{seq_order(ii)});
    else
        fprintf('%s,',db.seq_names{seq_order(ii)});
    end
end
disp('% ------ End of Matlab-generated LaTeX code ------')

%% Write to file

% Out folder
if ~exist(fullfile(paper_data, 'per_seq_plots'),'dir')
    mkdir(fullfile(paper_data, 'per_seq_plots'));
end

% Mean over techniques
write_to_file(fullfile(paper_data,'per_seq_plots','global_vs_gt_eval_per_seq.txt'), {'SeqId','mJ', 'stdJ', 'mF', 'stdF'}, [(1:length(db.seq_names))' mean(mJ(seq_order,:),2) mean(stdJ(seq_order,:),2) mean(mF(seq_order,:),2) mean(stdF(seq_order,:),2)] )

% Each technique separately
for ii=1:length(techniques)
    write_to_file(fullfile(paper_data,'per_seq_plots',[techniques_paper{ii} '_vs_gt_eval_per_seq.txt']), {'SeqId','mJ', 'stdJ', 'mF', 'stdF'}, [(1:length(db.seq_names))' mJ(seq_order,ii) stdJ(seq_order,ii) mF(seq_order,ii) stdF(seq_order,ii)] )
end

























%% Write per-seq to files
% disp(['WRITING: Files to ' fullfile(paper_data, 'per_seq_tables')])
% if ~exist(fullfile(paper_data, 'per_seq_tables'),'dir')
%     mkdir(fullfile(paper_data, 'per_seq_tables'));
% end
% mes_name_file = {'Jr', 'Fc', 'Ts'};
% stat_name_file = {'mean','recall','decay'};
% 
% for sel_meas=1:3
%     clear meas;
%     if sel_meas==1
%         meas{1} = all_J.mean;     % J Mean
%         meas{2} = all_J.recall;   % J Recall
%         meas{3} = all_J.decay;    % J Decay
%     elseif sel_meas==2;
%         meas{1} = all_F.mean;     % F Mean
%         meas{2} = all_F.recall;   % F Recall
%         meas{3} = all_F.decay;    % F Decay
%     else
%         meas{1} = all_T.mean;     % T Mean
%     end
%     colheadings = techniques;
%     rowheadings = db_seqs;
%     
%     for ii=1:length(meas)
%         data = meas{ii}';
%         wid = 10;
%         fms = {'f'};
%         colsep = ' ';
%         rowending = '';
%         fileID = fopen(fullfile(paper_data, 'per_seq_tables', ['per_seq_' mes_name_file{sel_meas} '_' stat_name_file{ii} '.txt']),'w');
%         displaytable(data,colheadings,wid,fms,rowheadings,fileID,colsep,rowending);
%         fclose(fileID);
%     end
% end


