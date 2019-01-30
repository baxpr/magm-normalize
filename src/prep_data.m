function [t1_file,seg_file] = prep_data(t1_file,seg_file,out_dir)

%% Copy files to working directory and unzip
% Assume the input images are .nii.gz format

copyfile(t1_file,[out_dir '/t1.nii.gz']);
system(['gunzip -f ' out_dir '/t1.nii.gz']);
t1_file = [out_dir '/t1.nii'];

copyfile(seg_file,[out_dir '/seg.nii.gz']);
system(['gunzip -f ' out_dir '/seg.nii.gz']);
seg_file = [out_dir '/seg.nii'];


