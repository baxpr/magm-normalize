function spm_jobman_compiled(matlabbatch,out_dir) %#ok<INUSL>

batch_file = fullfile(out_dir,'batch.mat');
save(batch_file,'matlabbatch');

% The command line for compiled SPM has pathspecs in it - we saved this in
% a file at compilation time.
fid = fopen(which('spm_cmd.txt'),'rt');
cmd = fgetl(fid);
fclose(fid);
cmd = [cmd ' batch '  batch_file];

disp(cmd);
system(cmd);

return
