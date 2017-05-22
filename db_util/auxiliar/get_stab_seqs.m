
%% Startup
db_set_properties(2017,1,'480p');
gt_set = 'trainval';
db_seq_list = db_seqs(gt_set);

%% Create list of all objects
all_obj = {};
all_seq = {};
for ii=1:length(db_seq_list)
    n_obj = length(db_read_annot(db_seq_list{ii},'00000'));
    for jj=1:n_obj
        all_obj{end+1} = [db_seq_list{ii} '-' num2str(jj)]; %#ok<SAGROW>
        all_seq{end+1} = db_seq_list{ii}; %#ok<SAGROW>
    end
end
        
%% Get the evaluation of GT
eval = eval_result('gt','T',gt_set);
[vals,ids] = sort(eval.T.mean);

sel_ids = ids(floor(end/4):end);
unstab_obj = sort(all_obj(sel_ids));

fprintf(['{''' unstab_obj{1}])
for ii=2:length(unstab_obj)
    fprintf([''', ''' unstab_obj{ii}])
end
fprintf('''}\n')

%% The same with sequences (those that have one unstable object)
db_set_properties(2016,0,'480p');
[db_seq_list, stab_obj]= db_seqs('trainval');
stab_seq_2016 = db_seq_list(stab_obj);
unstab_seq = setdiff(unique(sort(all_seq(sel_ids))),stab_seq_2016);

fprintf(['{''' unstab_seq{1}])
for ii=2:length(unstab_seq)
    fprintf([''', ''' unstab_seq{ii}])
end
fprintf('''}\n')

