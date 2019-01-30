function [t1_nii,seg_nii] = prep_data(t1_niigz,seg_niigz,out_dir)

%% Copy files to working directory and unzip
% Assume the input images are .nii.gz format

copyfile(t1_niigz,[out_dir '/t1.nii.gz']);
t1_nii = gunzip([out_dir '/t1.nii.gz']);
t1_nii = t1_nii{1};

copyfile(seg_niigz,[out_dir '/seg.nii.gz']);
seg_nii = gunzip([out_dir '/seg.nii.gz']);
seg_nii = seg_nii{1};

