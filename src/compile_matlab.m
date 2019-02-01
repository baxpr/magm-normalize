% Compile the matlab code so we can run it without a matlab license. To
% create a linux container, we need to compile on a linux machine. That
% means a VM, if we are working on OS X.
%
% We require on our compilation machine:
%     Matlab 2017a, including compiler, with license
%     Installation of SPM12, https://www.fil.ion.ucl.ac.uk/spm/software/spm12/
%
% The matlab version matters. If we compile with R2017a, it will only run
% under the R2017a Runtime.

% Where to find SPM12 on our compilation machine. Currently assuming r7219
spm_dir = '/opt/spm12';

% For the compiler to find all SPM dependencies, we need to do some stuff
% from spm_make_standalone.m in our SPM installation. This only needs to be
% done once for a given installation, but it won't make changes if it finds
% it has already run.
prep_spm_for_compile(spm_dir);

% Compile. Including the entire SPM directory structure with -a makes this
% slow, but avoids problems with missing bits later.
mkdir('../bin');

% Error using compile_matlab (line 25)
% Unexpected error while determining required deployable files. Compilation terminated. Details:
% Error using matlab.depfun.internal.database.SqlDbConnector/doSql
% Received exception (SQL error or missing database file:
mcc -m -C -N -v ...
-p [matlabroot '/toolbox/signal'] ...
-a spm_dir ...
-a . ...
-d ../bin ...
magm_normalize

%-I ${SPM_PATH} \
%-I ${SPM_PATH}/config \
%-I ${SPM_PATH}/matlabbatch \
%-I ${SPM_PATH}/matlabbatch/private \
%-I ${SPM_PATH}/matlabbatch/cfg_basicio \
%-a ${SPM_PATH}/Contents.txt \
%-a ${SPM_PATH}/canonical \
%-a ${SPM_PATH}/EEGtemplates \
%-a ${SPM_PATH}/toolbox \
%-a ${SPM_PATH}/tpm \

% We grant lenient execute permissions to the matlab executable and runscript so
% we don't have hiccups later.
%chmod go+rx bin/magm_normalize
%chmod go+rx bin/run_magm_normalize.sh

