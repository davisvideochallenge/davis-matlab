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
% This file shows the comparison table between all techniques and on all
% measures (Table 2 in the paper)
% ------------------------------------------------------------------------

% Get the parameters
clear;
experiments_params();

% Which set of the ground truth use
year = 2016;
db_set_properties(year,0,'480p');
gt_set = 'val';
[db_seq_list, stab_seqs]= db_seqs(gt_set);

%% Evaluate them or load pre-computed evaluation
F = cell(1,length(techniques));
J = cell(1,length(techniques));
T = cell(1,length(techniques));
for ii=1:length(techniques)
    eval = eval_result(techniques{ii},{'F','J','T'},gt_set);
    F{ii} = eval.F;
    J{ii} = eval.J;
    T{ii} = eval.T;
end
eval = eval_result('gt','T',gt_set);
Tgt  = eval.T;

%% Put them in a single matrix
all_F.mean   = zeros(length(techniques),length(F{1}.mean));
all_F.recall = zeros(length(techniques),length(F{1}.mean));
all_F.decay  = zeros(length(techniques),length(F{1}.mean));
all_J = all_F;
all_T.mean   = zeros(length(techniques),length(F{1}.mean));

for ii=1:length(techniques)
    all_F.mean(ii,:)   = F{ii}.mean;
    all_F.recall(ii,:) = F{ii}.recall;
    all_F.decay(ii,:)  = F{ii}.decay;

    all_J.mean(ii,:)   = J{ii}.mean;
    all_J.recall(ii,:) = J{ii}.recall;
    all_J.decay(ii,:)  = J{ii}.decay;  
    
    all_T.mean(ii,:)   = T{ii}.mean;
end

%% Display evaluation table
clc
disp(repmat('=',[1,165]))
fprintf('\t\t');
for ii=1:length(techniques), fprintf('%s\t',techniques{ii}), end; fprintf('\n');
disp(repmat('-',[1,165]))
fprintf('J mean  \t');fprintf('%0.3f\t',mean(all_J.mean,2)'); fprintf('\n');
fprintf('J recall\t');fprintf('%0.3f\t',mean(all_J.recall,2)'); fprintf('\n');
fprintf('J decay \t');fprintf('%0.3f\t',mean(all_J.decay,2)'); fprintf('\n');
disp(repmat('-',[1,165]))
fprintf('F mean  \t');fprintf('%0.3f\t',mean(all_F.mean,2)'); fprintf('\n');
fprintf('F recall\t');fprintf('%0.3f\t',mean(all_F.recall,2)'); fprintf('\n');
fprintf('F decay \t');fprintf('%0.3f\t',mean(all_F.decay,2)'); fprintf('\n');
disp(repmat('-',[1,165]))
fprintf('T (GT %0.3f)\t',mean(Tgt.mean(stab_seqs)));fprintf('%0.3f\t',mean(all_T.mean(:,stab_seqs),2)'); fprintf('\n');
disp(repmat('=',[1,165]))


%% Display evaluation table (in LaTeX)
% 
% % Define the groups of techniques to get the maximum values in bold
% max_groups = [1 1 1   2 2 2 2 2 2 2   3 3 3 3 3 3];
% 
% % Define if each measure is good max or min (T goes by its own)
% max_min = [1 1 0];
% 
% clc;
% disp('% ------ Matlab-generated LaTeX code ------')
% mes_name = {'$\mathcal{J}$', '  $\mathcal{F}$', '$\mathcal{T}$'};
% mes_color = {'rowblue', 'white','rowblue'};
% stat_names = {'Mean $\mathcal{M} \uparrow$','Recall $\mathcal{O} \uparrow$','Decay $\mathcal{D} \downarrow$','Mean $\mathcal{M} \downarrow$'};
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
% 
% 
%     
%     % Show the table
%     if sel_meas<3
%         names = {['	                         & ' stat_names{1} '    '],...
%                  ['\cellcolor{' mes_color{sel_meas} '}' mes_name{sel_meas} ' & ' stat_names{2} '  '],...
%                  ['	                         & ' stat_names{3} ' ']};
%     else
%         names = {['\cellcolor{' mes_color{sel_meas} '}' mes_name{sel_meas} ' & ' stat_names{4} '  ']};
%     end
%     for ii=1:length(meas)
%         if sel_meas<3
%             av = mean(meas{ii},2);
%         else
%             tmp = meas{ii};
%             av = mean(tmp(:,stab_seqs),2);
%         end
%         % Get the maximum on each of the groups
%         n_groups = length(unique(max_groups));
%         max_ids = zeros(1,n_groups);
%         for jj=1:n_groups
%             if max_min(ii) && sel_meas<3
%                 tmp = av; tmp(max_groups~=jj) = 0;
%                 [~, max_ids(jj)] = max(tmp);
%             else
%                 tmp = av; tmp(max_groups~=jj) = 1e10;
%                 [~, max_ids(jj)] = min(tmp);
%             end
%         end
%         
%         to_show = names{ii};
%         for jj=1:length(techniques)
%             if av(jj)<0, sp = ' '; else sp = '\ '; end
%             if ismember(jj,max_ids)
%                 to_show = [to_show ' &\bf' sp sprintf('%0.3f', av(jj))]; %#ok<AGROW>
%             else
%                 to_show = [to_show ' &   ' sp sprintf('%0.3f', av(jj))]; %#ok<AGROW>
%             end
%         end
%         disp([to_show ' \\']);
%     end
%     if sel_meas<3
%         disp('\hline');
%     end
% end
% disp('% ------ End of Matlab-generated LaTeX code ------')

%% Export in JSON for web
glob_eval.Tgt        = sprintf('%0.3f',mean(Tgt.mean(stab_seqs)));
glob_eval.techniques = strrep(techniques,'-','');
for ii=1:length(techniques) 
    id = strrep(techniques{ii},'-','');
    glob_eval.(id).Jmean      = sprintf('%0.3f',mean(all_J.mean(ii,:)));
    glob_eval.(id).Jrecall    = sprintf('%0.3f',mean(all_J.recall(ii,:)));
    glob_eval.(id).Jdecay     = sprintf('%0.3f',mean(all_J.decay(ii,:)));
    glob_eval.(id).Fmean      = sprintf('%0.3f',mean(all_F.mean(ii,:)));
    glob_eval.(id).Frecall    = sprintf('%0.3f',mean(all_F.recall(ii,:)));
    glob_eval.(id).Fdecay     = sprintf('%0.3f',mean(all_F.decay(ii,:)));
    glob_eval.(id).T          = sprintf('%0.3f',mean(all_T.mean(ii,stab_seqs)));
end
filename = ['global_eval_' gt_set '_' num2str(year) '.js'];
savejson('',glob_eval,filename);

% Add var ... =
content = fileread(filename);
content = ['var global_eval_' gt_set '_' num2str(year) ' = ', content];
fid = fopen(filename,'w');
fwrite(fid, content, 'char');
fclose(fid);


%% Show all means
% figure;
% plot(all_T.mean')
% hold on
% plot(Tgt.mean,'k--');
% legend([techniques(:); 'GT'])


