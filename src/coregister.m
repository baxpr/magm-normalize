function mtx_file = coregister(src_file,tgt_file,out_dir)

% src and tgt should be a single volume (3D). We will capture and combine
% the COM shift and the coreg to save the initial 6 DOF transformation
% matrix that will be required before applying the estimated deformation
% later.	

% Find image centers of mass
tgt_com = find_center_of_mass(tgt_file);
src_com = find_center_of_mass(src_file);

% How to move the src image
src_shift = tgt_com - src_com;
src_shift_mat = spm_matrix(src_shift);

% SPM file handles
srcV = spm_vol(src_file);
tgtV = spm_vol(tgt_file);

% Update the src geometry with the COM matrix
srcV.mat = src_shift_mat * srcV.mat;

% Compute the coregistration
coreg_vec = spm_coreg(tgtV,srcV);
coreg_mat = spm_matrix(coreg_vec);

% Combined matrix
total_mat = src_shift_mat / coreg_mat;

% Save matrix to file
mtx_file = [out_dir '/initial_coreg_mat.txt'];
save(mtx_file,'total_mat','-ascii');

