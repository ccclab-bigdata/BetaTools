figDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Beta\Ketamine\figures';
figFiles = dir(fullfile(figDir,'bispectrum_*.fig'));

for curFile=1:length(figFiles)
    h=openfig(fullfile(figDir,figFiles(curFile).name));
    caxis([-20 60]);
    saveas(h,fullfile(figDir,['bispectrum_',num2str(curFile),'.png']),'png');
    saveas(h,fullfile(figDir,figFiles(curFile).name),'fig');
    close(h);
end