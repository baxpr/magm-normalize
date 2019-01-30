function src_file = make_source(seg_file,out_dir)


%% Make native space source image. WM=1, GM=2.

% Load image
segV = spm_vol(seg_file);
seg = spm_read_vols(segV);

% Tissue classes:
% CSF =  4 11 49 50 51 52
% WM  = 35 40 41 44 45 61 62 (include diencephalon 61,62 to match template)
% GM  = everything else > 0
csf_list = [4 11 49 50 51 52];
wm_list = [35 40 41 44 45 61 62];
csf = ismember(seg,csf_list);
wm  = ismember(seg,wm_list);
gm  = seg>0 & ~ismember(seg,csf_list) & ~ismember(seg,wm_list);

% WM + GM pseudo-T1 does not work well
%src = 2 * wm + 1 * gm;

% Grey matter alone works better
src = gm;

srcV = rmfield(segV,'pinfo');
src_file = [out_dir '/src.nii'];
srcV.fname = src_file;
spm_write_vol(srcV,src);



