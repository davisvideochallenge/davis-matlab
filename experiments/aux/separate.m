% %% Separate
% techniques = {'gt'};
% measures   = {'T'};
% for ii=1:length(techniques) %#ok<USENS>
%     raw_eval = loadvar(fullfile(db_matlab_root_dir,'eval_results',[techniques{ii} '.mat']),'raw_eval');
%     
%     seq_ids = db_seqs();
%     assert(length(raw_eval)==length(seq_ids))
%     
%     sel_eval = cell(length(measures),length(seq_ids));
% 
%     for jj=1:length(seq_ids)
%         assert(isequal(raw_eval{jj}.seq_id,seq_ids{jj}))
%         for kk=1:length(measures)
%             sel_eval{kk,jj} = raw_eval{jj}.(measures{kk});
%         end
%     end
%     
%     for kk=1:length(measures)
%         raw_ev = sel_eval(kk,:); %#ok<NASGU>
%         save(fullfile(db_matlab_root_dir,'eval_results',[techniques{ii} '_' measures{kk} '.mat']),'raw_ev','-v7.3');
%     end
% end