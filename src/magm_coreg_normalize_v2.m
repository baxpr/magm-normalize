function magm_coreg_normalize_v2( ...
	t1_file, ...
	seg_file, ...
	out_dir, ...
	spm_dir, ...
	project, ...
	subject, ...
	session, ...
	scan ...
	)

% Check versions and initialize
disp('Version check')
addpath(spm_dir);
spm_jobman('initcfg');
vercheck('R2015a','SPM12 (6225)',[])

% Unzip files and copy to working dir
disp('Prepping files')
[t1_file,seg_file] = prep_data(t1_file,seg_file,out_dir);

% Compute atlas space target image from SPM12 / Neuromorph atlas
disp('Computing target image')
tgt_file = make_target(spm_dir,out_dir);

% Compute native space source image from multiatlas output
disp('Computing source image')
src_file = make_source(seg_file,out_dir);

% Align centers of mass and initial 6 DOF registration
disp('Initial rigid body registration')
mtx_file = coregister(src_file,tgt_file,out_dir);

% Apply 6 DOF transform to input images
disp('Apply rigid body transform')
csrc_file = apply_coreg_transform(mtx_file,src_file,out_dir);
ct1_file = apply_coreg_transform(mtx_file,t1_file,out_dir);
cseg_file = apply_coreg_transform(mtx_file,seg_file,out_dir);

% "Old Normalise" to estimate warp. This produces 'x' prefix files that are
% created within the module.
disp('Estimate normalise / nonlinear warp')
[~,~,~,fwddef_file,invdef_file] = old_normalize( ...
	csrc_file,tgt_file,ct1_file,cseg_file);

% Use custom apply-warp code to create final 'w' warped images. This is
% done this way to verify that the image-based deformation method is
% working properly.
disp('Apply nonlinear warp')
nsrc_file = apply_warp(fwddef_file,csrc_file,0);
nt1_file = apply_warp(fwddef_file,ct1_file,1);
nseg_file = apply_warp(fwddef_file,cseg_file,0);

% PDF output report
disp('Generate PDF')
pdf_file = make_report( ...
	tgt_file,nsrc_file,nt1_file,out_dir, ...
	project,subject,session,scan);

% Zip up output images
disp('Zipping output images')
zip_outputs(out_dir);

