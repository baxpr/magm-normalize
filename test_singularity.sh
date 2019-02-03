# Usage

singularity run \
--cleanenv \
--home `pwd`/INPUTS \
--bind `pwd`/INPUTS:/INPUTS \
--bind `pwd`/OUTPUTS:/OUTPUTS \
baxpr-magm-normalize-master-v3.0.0.simg \
t1_niigz /INPUTS/t1.nii.gz \
seg_niigz /INPUTS/seg.nii.gz \
out_dir /OUTPUTS \
xnat_proj TEST_PROJ \
xnat_subj TEST_SUBJ \
xnat_sess TEST_SESS \
xnat_t1scan TEST_SCAN
