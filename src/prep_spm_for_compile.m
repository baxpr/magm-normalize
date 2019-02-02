function prep_spm_for_compile(spm_dir)

% Prep SPM installation for compilation with -a flag. Modified from
% spm_make_standalone.m of SPM r7219

addpath(spm_dir);
addpath(fullfile(spm_dir,'config'));
addpath(fullfile(spm_dir,'matlabbatch'));

% Only run this if we haven't run it before
if exist(fullfile(spm_dir,'Contents.txt'),'file')
	disp('Looks like we already prepped the SPM dir')
	return
else
	disp(['Updating ' spm_dir ' for compilation'])
end

% The eeg toolbox config is broken (uses spm_select to find functions, and
% doesn't have an isdeployed section for compiled version). The easy
% solution is to turn it off, assuming we don't need it
system(['sed -i ''s/' ...
	'spmjobs.values = { temporal spatial stats dcm spm_cfg_eeg util tools };' ...
	'/' ...
	'spmjobs.values = { temporal spatial stats dcm util tools };' ...
	'/'' ' spm_dir '/config/spm_cfg.m']);


%% The remaining copied from spm_make_standalone.m, without the mcc step

%==========================================================================
%-Static listing of SPM toolboxes
%==========================================================================
fid = fopen(fullfile(spm('Dir'),'config','spm_cfg_static_tools.m'),'wt');
fprintf(fid,'function values = spm_cfg_static_tools\n');
fprintf(fid,...
    '%% Static listing of all batch configuration files in the SPM toolbox folder\n');
%-Get the list of toolbox directories
tbxdir = fullfile(spm('Dir'),'toolbox');
d = [tbxdir; cellstr(spm_select('FPList',tbxdir,'dir'))];
ft = {};
%-Look for '*_cfg_*.m' files in these directories
for i=1:numel(d)
    fi = spm_select('List',d{i},'.*_cfg_.*\.m$');
    if ~isempty(fi)
        ft = [ft(:); cellstr(fi)];
    end
end
%-Create code to insert toolbox config
if isempty(ft)
    ftstr = '';
else
    ft = spm_file(ft,'basename');
    ftstr = sprintf('%s ', ft{:});
end
fprintf(fid,'values = {%s};\n', ftstr);
fclose(fid);

%==========================================================================
%-Static listing of batch application initialisation files
%==========================================================================
cfg_util('dumpcfg');

%==========================================================================
%-Duplicate Contents.m in Contents.txt for use in spm('Ver')
%==========================================================================
sts = copyfile(fullfile(spm('Dir'),'Contents.m'),...
               fullfile(spm('Dir'),'Contents.txt'));
if ~sts, warning('Copy of Contents.m failed.'); end



