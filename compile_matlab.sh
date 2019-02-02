#!/bin/sh
#
# Compile the matlab code so we can run it without a matlab license. To create a 
# linux container, we need to compile on a linux machine. That means a VM, if we 
# are working on OS X.
#
# We require on our compilation machine:
#     Matlab 2017a, including compiler, with license
#     Installation of SPM12, https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
#
# The matlab version matters. If we compile with R2017a, it will only run under 
# the R2017a Runtime.

# Where to find SPM12 on our compilation machine. Currently assuming r7219
SPM_PATH=/opt/spm12

# We may need to add Matlab to the path on the compilation machine
export MAT_PATH=/usr/local/MATLAB/R2017a
export PATH=${MAT_PATH}/bin:${PATH}

# For the compiler to find all SPM dependencies, we need to do some stuff from 
# spm_make_standalone.m in our SPM installation. This only needs to be done once
# for a given installation, but it won't make changes if it finds it has already
# run.
matlab -nodisplay -nodesktop -nosplash -sd src -r \
    "prep_spm_for_compile('${SPM_PATH}'); exit"

# Compile
mkdir -p bin
mcc -m -v \
-R -singleCompThread -w disable \
-I ${SPM_PATH} \
-I ${SPM_PATH}/config \
-I ${SPM_PATH}/matlabbatch \
-I ${SPM_PATH}/matlabbatch/cfg_basicio \
-a ${SPM_PATH}/Contents.txt \
-a ${SPM_PATH}/canonical \
-a ${SPM_PATH}/EEGtemplates \
-a ${SPM_PATH}/toolbox \
-a ${SPM_PATH}/tpm \
-a src \
-d bin \
src/magm_normalize.m


# We grant lenient execute permissions to the matlab executable and runscript so
# we don't have hiccups later.
chmod go+rx bin/magm_normalize
chmod go+rx bin/run_magm_normalize.sh

