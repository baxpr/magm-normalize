function [nsrc_file,nt1_file,nseg_file,fwddef_file,invdef_file] = ...
	old_normalize(csrc_file,tgt_file,ct1_file,cseg_file)

% Set up
clear matlabbatch
tag = 0;

% Pre-compute some filenames
[psrc,nsrc,esrc] = fileparts(csrc_file);
snmat_file = fullfile(psrc,[nsrc '_sn.mat']);
fwddef_file = fullfile(psrc,['y_' nsrc '_sn.nii']);
isn_mat_file = fullfile(psrc,['i' nsrc '_sn.mat']);
invdef_file = fullfile(psrc,['iy_' nsrc '_sn.nii']);
nsrc_file = fullfile(psrc,['x' nsrc esrc]);

[pt1,nt1,et1] = fileparts(ct1_file);
nt1_file = fullfile(pt1,['x' nt1 et1]);

[pseg,nseg,eseg] = fileparts(cseg_file);
nseg_file = fullfile(pseg,['x' nseg eseg]);


% Normalize ROI images with NN interp
tag = tag + 1;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.source = {csrc_file};
matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.wtsrc = '';
matlabbatch{tag}.spm.tools.oldnorm.estwrite.subj.resample = ...
	{csrc_file; cseg_file};
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.template = ...
	{tgt_file};
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.weight = '';
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.smosrc = 8;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.smoref = 8;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.regtype = 'mni';
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.cutoff = 25;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.nits = 16;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.eoptions.reg = 1;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.preserve = 0;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.bb = ...
	[-78 -112 -70; 78 76 85];
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.vox = [1 1 1];
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.interp = 0;
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.wrap = [0 0 0];
matlabbatch{tag}.spm.tools.oldnorm.estwrite.roptions.prefix = 'x';


% Use same warp to normalize T1 with linear interp
tag = tag + 1;
matlabbatch{tag}.spm.tools.oldnorm.write.subj.matname = {snmat_file};
matlabbatch{tag}.spm.tools.oldnorm.write.subj.resample = {ct1_file};
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.preserve = 0;
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.bb = ...
	[-78 -112 -70; 78 76 85];
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.vox = [1 1 1];
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.interp = 1;
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.wrap = [0 0 0];
matlabbatch{tag}.spm.tools.oldnorm.write.roptions.prefix = 'x';


% Compute forward deformation field from sn.mat
tag = tag + 1;
matlabbatch{tag}.spm.util.defs.comp{1}.sn2def.matname = {snmat_file};
matlabbatch{tag}.spm.util.defs.comp{1}.sn2def.vox = [NaN NaN NaN];
matlabbatch{tag}.spm.util.defs.comp{1}.sn2def.bb = ...
		[NaN NaN NaN; NaN NaN NaN];
matlabbatch{tag}.spm.util.defs.out{1}.savedef.ofname = snmat_file;
matlabbatch{tag}.spm.util.defs.out{1}.savedef.savedir.saveusr = {psrc};


% Inverse deformation field. We need to rename this file afterwards to
% match SPM conventions
tag = tag + 1;
matlabbatch{tag}.spm.util.defs.comp{1}.sn2def.matname = {snmat_file};
matlabbatch{tag}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.vox = [NaN NaN NaN];
matlabbatch{tag}.spm.util.defs.comp{1}.inv.comp{1}.sn2def.bb = ...
	[NaN NaN NaN; NaN NaN NaN];
matlabbatch{tag}.spm.util.defs.comp{1}.inv.space = {csrc_file};
matlabbatch{tag}.spm.util.defs.out{1}.savedef.ofname = isn_mat_file;
matlabbatch{tag}.spm.util.defs.out{1}.savedef.savedir.saveusr = {psrc};

% Run all jobs
batch_file = fullfile(psrc,'batch.mat');
save(batch_file,'matlabbatch');
spm_standalone('batch',batch_file);

% Rename deformation files
movefile( ...
	fullfile(psrc,['y_i' nsrc '_sn.nii']), ...
	fullfile(psrc,['iy_' nsrc '_sn.nii']) );

