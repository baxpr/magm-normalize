function magm_normalize(varargin)


%% Parse inputs

% Initialize the inputs structure
P = inputParser;

addOptional(P,'t1_niigz','/INPUTS/t1.nii.gz');
addOptional(P,'seg_niigz','/INPUTS/seg.nii.gz');
addOptional(P,'out_dir','/OUTPUTS');
addOptional(P,'xnat_proj','UNK_PROJ');
addOptional(P,'xnat_subj','UNK_SUBJ');
addOptional(P,'xnat_sess','UNK_SESS');
addOptional(P,'xnat_t1scan','UNK_SCAN');

parse(P,varargin{:});

t1_niigz   = P.Results.t1_niigz;
seg_niigz = P.Results.seg_niigz;
out_dir    = P.Results.out_dir;

xnat_proj   = P.Results.xnat_proj;
xnat_subj   = P.Results.xnat_subj;
xnat_sess   = P.Results.xnat_sess;
xnat_t1scan = P.Results.xnat_t1scan;

fprintf('%s %s %s %s\n', ...
	xnat_proj,xnat_subj,xnat_sess,xnat_t1scan);
fprintf('t1_niigz:   %s\n', t1_niigz   );
fprintf('seg_niigz: %s\n', seg_niigz );
fprintf('out_dir:    %s\n', out_dir   );



%% Processing pipeline
magm_normalize_pipeline( ...
	t1_niigz,seg_niigz,out_dir, ...
	xnat_proj,xnat_subj,xnat_sess,xnat_t1scan ...
	);

if isdeployed, exit, end


