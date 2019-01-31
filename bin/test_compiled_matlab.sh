#!/bin/sh
#
# Test the compiled matlab. This runs on the compilation machine (linux).
sh run_magm_normalize.sh /usr/local/MATLAB/MATLAB_Runtime/v92 \
t1_niigz ../INPUTS/t1.nii.gz \
seg_niigz ../INPUTS/seg.nii.gz \
out_dir ../OUTPUTS \
xnat_proj TEST_PROJ \
xnat_subj TEST_SUBJ \
xnat_sess TEST_SESS \
xnat_t1scan TEST_SCAN
