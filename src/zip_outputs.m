function zip_outputs(out_dir)

% Gzip the nifti output images. Lots of assumptions here about what the
% filenames are
system(['gzip ' out_dir '/src.nii']);
system(['gzip ' out_dir '/cseg.nii']);
system(['gzip ' out_dir '/csrc.nii']);
system(['gzip ' out_dir '/ct1.nii']);
system(['gzip ' out_dir '/rtgt.nii']);
system(['gzip ' out_dir '/y_csrc_sn.nii']);
system(['gzip ' out_dir '/iy_csrc_sn.nii']);
system(['gzip ' out_dir '/wcseg.nii']);
system(['gzip ' out_dir '/wcsrc.nii']);
system(['gzip ' out_dir '/wct1.nii']);

