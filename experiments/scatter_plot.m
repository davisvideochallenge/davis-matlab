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
% This file shows:
%   - The scatter plot between measures (Fig. 3 in the paper)
%   - The correlation table between measures
% ------------------------------------------------------------------------

% Get the parameters
experiments_params();

%% Evaluate them or load pre-computed evaluation
raw_eval = cell(1,length(techniques));
for ii=1:length(techniques)
    [~,~,~,raw_eval{ii}] = eval_result(techniques{ii});
end


%% Get per-frame quality
for ii=1:length(techniques)
    
    % Gather all frames together
    per_frame_F{ii}    = []; %#ok<SAGROW>
    per_frame_J{ii}    = []; %#ok<SAGROW>
    per_frame_T{ii}    = []; %#ok<SAGROW>
    per_frame_s_id{ii} = []; %#ok<SAGROW>
    per_frame_f_id{ii} = []; %#ok<SAGROW>
    
    for s_id = 1:length(stab_seqs)
        % Save current result
        curr = raw_eval{ii}{stab_seqs(s_id)};
        
        % Remove frames without contours (NaN)
        sel_frames = ~isnan(curr.T);
        n_frames = sum(sel_frames);
        
        % Put all together
        per_frame_s_id{ii} = [per_frame_s_id{ii} ones(1,n_frames)*s_id]; %#ok<SAGROW>
        per_frame_f_id{ii} = [per_frame_f_id{ii} 1:n_frames];            %#ok<SAGROW>
        per_frame_F{ii}    = [per_frame_F{ii}    curr.F(sel_frames)];    %#ok<SAGROW>
        per_frame_J{ii}    = [per_frame_J{ii}    curr.J(sel_frames)];    %#ok<SAGROW>
        per_frame_T{ii}    = [per_frame_T{ii}    curr.T(sel_frames)];    %#ok<SAGROW>
    end
end


%% Write per-frame scatter to file (only on selected by temporal)
disp(['WRITING: Files to ' fullfile(paper_data, 'scatter')])
if ~exist(fullfile(paper_data, 'scatter'),'dir')
    mkdir(fullfile(paper_data, 'scatter'));
end
for r_id=1:length(techniques)
    % Write per-frame scatter to file
    res_file = fullfile(paper_data, 'scatter',[techniques{r_id} '_vs_gt_eval_per_frame.txt']);
    write_to_file(res_file,{'SeqId','J','F','T'},[per_frame_s_id{r_id}' per_frame_J{r_id}' per_frame_F{r_id}' per_frame_T{r_id}'])
end


%% Compute the correlation and show the table
all_corr  = zeros(2,length(techniques_paper));
for ii=1:length(techniques_paper)
    rho1 = corrcoef(per_frame_J{ii},per_frame_F{ii});
    rho2 = corrcoef(per_frame_T{ii},per_frame_F{ii});

    all_corr(1,ii) = rho1(1,2);
    all_corr(2,ii) = rho2(1,2);
end
m_corr = mean(all_corr,2);

% Display LaTeX
disp('% ----- LaTeX code ------')
% Header
line0 = 'Measure';
for ii=1:length(techniques_paper)
   line0 = [line0 ' & ' strrep(techniques_paper{ii},'-','') ];   %#ok<AGROW>
end
disp([line0 ' & Mean\\'])
disp('\midrule')


% Table
line1 = '$J$ - $F$         ';
line2 = '$T$ - $F$         ';
for ii=1:length(techniques_paper)
   line1 = [line1 sprintf('& %0.3f ',all_corr(1,ii))];   %#ok<AGROW>
   line2 = [line2 sprintf('& %0.3f ',all_corr(2,ii))];   %#ok<AGROW>
end
disp([line1 sprintf('& %0.3f ',m_corr(1)) ' \\'])
disp([line2 sprintf('& %0.3f ',m_corr(2)) ' \\'])
disp('% ----- End of LaTeX code ------')









