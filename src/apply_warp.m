function nimg_file = apply_warp(fwddef_file,img_file,interp)

% Forward deformation image with "pullback" and bounding box/voxel size
% specified.

clear matlabbatch

[p,n,e] = fileparts(img_file);
nimg_file = fullfile(p,['w' n e]);

matlabbatch{1}.spm.util.defs.comp{1}.def = {fwddef_file};
matlabbatch{1}.spm.util.defs.comp{2}.idbbvox.vox = [1 1 1];
matlabbatch{1}.spm.util.defs.comp{2}.idbbvox.bb = [-78 -112 -70
                                                   78 76 85];
matlabbatch{1}.spm.util.defs.out{1}.pull.fnames = {img_file};
matlabbatch{1}.spm.util.defs.out{1}.pull.savedir.savesrc = 1;
matlabbatch{1}.spm.util.defs.out{1}.pull.interp = interp;
matlabbatch{1}.spm.util.defs.out{1}.pull.mask = 0;
matlabbatch{1}.spm.util.defs.out{1}.pull.fwhm = [0 0 0];

batch_file = fullfile(p,'batch.mat');
save(batch_file,'matlabbatch');
spm_standalone('batch',batch_file);

