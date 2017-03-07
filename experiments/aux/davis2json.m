function davis2json(meth_id, out_file, gt_set)

if nargin==0
    gt_set = 'val';
    meth_id = 'osvos';
    res_folder = '.';
    out_file = fullfile(res_folder,[strrep(meth_id,'-',''), '_davis.json']);
end

% Open out file
fid = fopen(out_file,'w');
fprintf(fid,'{"id" : "%s",\n',strrep(meth_id,'-',''));

% Read evaluation
[~, raw_ev] = eval_result(meth_id,{'J','F'},gt_set);
experiments_params();

% Scan all sequences
seq_ids = db_seqs(gt_set);
for ii=1:length(seq_ids)
    fprintf(fid,'  "%s" : {\n',seq_ids{ii});
    fprintf(seq_ids{ii})
    
    % Print J
    fprintf(fid,'      "J" : [');
    fprintf(fid,'"%0.3f", ', raw_ev.J{ii}(1:end-1));
    fprintf(fid,'"%0.3f"],\n',raw_ev.J{ii}(end));
    
    % Print F
    fprintf(fid,'      "F" : [');
    fprintf(fid,'"%0.3f", ', raw_ev.F{ii}(1:end-1));
    fprintf(fid,'"%0.3f"]}',raw_ev.F{ii}(end));
    
    if ii<length(seq_ids)
        fprintf(fid,',');
    end
    fprintf(fid,'\n');
    fprintf('\n');
end
fprintf(fid,'}\n');


fclose(fid);