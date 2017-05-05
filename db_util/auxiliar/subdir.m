function s_dirs = subdir(path)

tmp = dir(path);
s_dirs = {tmp.name};
s_dirs(~[tmp.isdir]) = [];
s_dirs(strcmp(s_dirs,'.')) = [];
s_dirs(strcmp(s_dirs,'..')) = [];


