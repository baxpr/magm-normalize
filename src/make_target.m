function tgt_file = make_target(out_dir)

%% Make atlas space target image. WM=1, GM=2, weighted average from atlas

gm_file = [spm('dir') '/tpm/TPM.nii,1'];
gmV = spm_vol(gm_file);
gm = spm_read_vols(gmV);

wm_file = [spm('dir') '/tpm/TPM.nii,2'];
wmV = spm_vol(wm_file);
wm = spm_read_vols(wmV);

%tgt = 2 * wm + 1 * gm;
tgt = gm;

tgtV = rmfield(gmV,'pinfo');
tgt_file = [out_dir '/tgt.nii'];
tgtV.fname = tgt_file;
spm_write_vol(tgtV,tgt);



