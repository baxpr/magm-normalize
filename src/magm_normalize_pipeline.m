function magm_normalize_pipeline( ...
	t1_niigz, ...
	seg_niigz, ...
	out_dir, ...
	xnat_proj, ...
	xnat_subj, ...
	xnat_sess, ...
	xnat_t1scan ...
	)

% Set up for SPM batch jobs
%spm_setup_jobman;

% Unzip files and copy to working dir
disp('Prepping files')
[t1_nii,seg_nii] = prep_data(t1_niigz,seg_niigz,out_dir);

% Compute atlas space target image from SPM12 / Neuromorph atlas
disp('Computing target image')
tgt_nii = make_target(out_dir);

% Compute native space source image from multiatlas output
disp('Computing source image')
src_nii = make_source(seg_nii,out_dir);

% Align centers of mass and initial 6 DOF registration
disp('Initial rigid body registration')
mtx_file = coregister(src_nii,tgt_nii,out_dir);

% Apply 6 DOF transform to input images
disp('Apply rigid body transform')
csrc_nii = apply_coreg_transform(mtx_file,src_nii,out_dir);
ct1_nii = apply_coreg_transform(mtx_file,t1_nii,out_dir);
cseg_nii = apply_coreg_transform(mtx_file,seg_nii,out_dir);

% "Old Normalise" to estimate warp. This produces 'x' prefix files that are
% created within the module.
disp('Estimate normalise / nonlinear warp')
[~,~,~,fwddef_nii,invdef_nii] = old_normalize( ...
	csrc_nii,tgt_nii,ct1_nii,cseg_nii);

% Use custom apply-warp code to create final 'w' warped images. This is
% done this way to verify that the image-based deformation method is
% working properly.
disp('Apply nonlinear warp')
wcsrc_nii = apply_warp(fwddef_nii,csrc_nii,0);
wct1_nii = apply_warp(fwddef_nii,ct1_nii,1);
wcseg_nii = apply_warp(fwddef_nii,cseg_nii,0);

% PDF output report
disp('Generate PDF')
pdf_file = make_report(tgt_nii,wcsrc_nii,wct1_nii,out_dir, ...
	xnat_proj,xnat_subj,xnat_sess,xnat_t1scan);

% Zip up output images
disp('Zipping output images')
zip_outputs(out_dir);

