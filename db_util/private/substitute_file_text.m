function substitute_file_text( file, text )
    fid = fopen(file,'w');
    fprintf(fid,'%s',text);
    fclose(fid);
end

