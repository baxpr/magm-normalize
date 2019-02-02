function spm_jobman_single(matlabbatch)

% From spm_standalone.m

spm('defaults','fmri');
spm_get_defaults('cmdline',true);
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);
spm('Quit');
