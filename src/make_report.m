function pdf_file = make_report(tgt_nii,wcsrc_nii,wct1_nii,out_dir, ...
	xnat_proj,xnat_subj,xnat_sess,xnat_t1scan)

% Resample target image to src output geometry so slices match up
clear matlabbatch
matlabbatch{1}.spm.spatial.coreg.write.ref = {wcsrc_nii};
matlabbatch{1}.spm.spatial.coreg.write.source = {tgt_nii};
matlabbatch{1}.spm.spatial.coreg.write.roptions.interp = 1;
matlabbatch{1}.spm.spatial.coreg.write.roptions.wrap = [0 0 0];
matlabbatch{1}.spm.spatial.coreg.write.roptions.mask = 0;
matlabbatch{1}.spm.spatial.coreg.write.roptions.prefix = 'r';
spm_jobman('run',matlabbatch);
[p,n,e] = fileparts(tgt_nii);
rtgt_nii = fullfile(p,['r' n e]);

% Load image data
tgt = spm_read_vols(spm_vol(rtgt_nii));
src = spm_read_vols(spm_vol(wcsrc_nii));
t1 = spm_read_vols(spm_vol(wct1_nii));

% Figure out screen size so the figure will fit
ss = get(0,'screensize');
ssw = ss(3);
ssh = ss(4);
ratio = 8.5/11;
if ssw/ssh >= ratio
	dh = ssh;
	dw = ssh * ratio;
else
	dw = ssw;
	dh = ssw / ratio;
end

% Open figure
f1 = openfig('pdf_fig.fig','new');
set(f1,'Position',[0 0 dw dh]);
figH = guihandles(f1);
colormap(gray)

% Info and stats
set(figH.date,'String',date);
set(figH.stats, 'String', sprintf( ...
	'%s %s %s %s', ...
	xnat_proj,xnat_subj,xnat_sess,xnat_t1scan) );

% Slices
slicepos = [38 52 88 124];
for s = 1:4
	
	ax = ['tgt' num2str(s)];
	axes(figH.(ax))
	imagesc( ...
		imrotate( ...
		squeeze(tgt(:,:,slicepos(s))), 90 ...
		), [0 2])
	axis image off
	
	ax = ['src' num2str(s)];
	axes(figH.(ax))
	imagesc( ...
		imrotate( ...
		squeeze(src(:,:,slicepos(s))), 90 ...
		), [0 2])
	axis image off
	
	ax = ['t1' num2str(s)];
	axes(figH.(ax))
	imagesc( ...
		imrotate( ...
		squeeze(t1(:,:,slicepos(s))), 90 ...
		) )
	axis image off
	
end

% Print to file
pdf_file = fullfile(out_dir,'magm_normalize.pdf');
print(f1,'-dpdf',pdf_file)

