function zip_outputs(out_dir)

% Gzip the nifti output images. Lots of assumptions here about what the
% filenames are
gzip(fullfile(out_dir,'src.nii'));
gzip(fullfile(out_dir,'cseg.nii'));
gzip(fullfile(out_dir,'csrc.nii'));
gzip(fullfile(out_dir,'ct1.nii'));
gzip(fullfile(out_dir,'rtgt.nii'));
gzip(fullfile(out_dir,'y_csrc_sn.nii'));
gzip(fullfile(out_dir,'iy_csrc_sn.nii'));
gzip(fullfile(out_dir,'wcseg.nii'));
gzip(fullfile(out_dir,'wcsrc.nii'));
gzip(fullfile(out_dir,'wct1.nii'));

