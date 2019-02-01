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
#matlab -nodisplay -nodesktop -nosplash -sd src -r \
#    "prep_spm_for_compile('${SPM_PATH}'); exit"

# To use spm_jobman for batch jobs, we'll additionally have to compile SPM 
# itself using spm_make_standalone.m. We save the command line to call compiled
# SPM to a file where we can get it later, because it has specific path info 
# that is available now.
mkdir -p ${SPM_PATH}/standalone
matlab -nodisplay -nodesktop -nosplash -sd ${SPM_PATH}/config -r \
    "addpath('${SPM_PATH}'); spm_make_standalone('${SPM_PATH}/standalone'); exit"
echo "${SPM_PATH}/standalone/run_spm12.sh ${MAT_PATH} " > src/spm_cmd.txt


mkdir -p bin

## EEG toolbox is a problem when we use spm_jobman compiled. It has several places
# e.g. spm_cfg_eeg_artefact where it uses spm_select to inventory its own
# function files, which don't exist in the compiled environment perhaps? Possibly
# the issue is with spm('dir') ?

### This one compiles, but with
# -I ${SPM_PATH}/config \
# -I ${SPM_PATH}/matlabbatch \
# -I ${SPM_PATH}/matlabbatch/cfg_basicio \
#
# Item matlabbatch: No repeat named
# spm
# Undefined function 'list' for input arguments of type 'cell'.
# Error in cfg_repeat/list (line 112)
# Error in cfg_util>local_getcjid2subs (line 1352)
# Error in cfg_util>local_initjob (line 1537)
# Error in cfg_util (line 802)
# Error in spm_jobman (line 246)
# Error in old_normalize (line 45)
#
# https://www.jiscmail.ac.uk/cgi-bin/webadmin?A2=ind1305&L=spm&D=0&P=259910
#
# Change -I to -a on matlabbatch and we get the compile errors again.
mcc -m -v \
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


### Compile failure here:
# with or without -C :
#     Internal Error: Could not determine class of method
#     "/opt/spm12/@nifti/Contents.m". Number of classes checked: 17.
#     ...
#     Error: could not add DEPFUN manifest to CTF archive.
#
# Delete all Contents.m first : Same but 
#     "/opt/spm12/@slover/private/actc.mat". Number of classes checked: 18.
#mcc -m -C -N -v \
#-p ${MAT_PATH}/toolbox/signal \
#-a ${SPM_PATH} \
#-a src \
#-d bin \
#src/magm_normalize.m


#-I ${SPM_PATH} \
#-I ${SPM_PATH}/config \
#-I ${SPM_PATH}/matlabbatch \
#-I ${SPM_PATH}/matlabbatch/cfg_basicio \
#-a ${SPM_PATH}/Contents.txt \
#-a ${SPM_PATH}/canonical \
#-a ${SPM_PATH}/EEGtemplates \
#-a ${SPM_PATH}/toolbox \
#-a ${SPM_PATH}/tpm \

# We grant lenient execute permissions to the matlab executable and runscript so
# we don't have hiccups later.
chmod go+rx bin/magm_normalize
chmod go+rx bin/run_magm_normalize.sh

