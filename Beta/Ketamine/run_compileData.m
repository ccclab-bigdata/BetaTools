dataDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Raw\Spider Man\2014-11-25\Morning';
NSxFiles = dir(fullfile(dataDir,'*.ns5'));

channel = 12;

allData = [];
for fileIdx=1:length(NSxFiles)
    disp(NSxFiles(fileIdx).name);
    NSx = openNSx(fullfile(dataDir,NSxFiles(fileIdx).name),'read');
    allData = [allData NSx.Data(channel,:)];
end

pieces = findCleanSpans(allData,thresh,chopSamples);
disp(['pieces:',num2str(length(pieces))]);