%dataDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Raw\Spider Man\2014-11-25\Morning';
dataDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Raw\Spider Man\2014-11-25\Afternoon';
NSxFiles = dir(fullfile(dataDir,'*.ns5'));

%allData = []; % !!!UNCOMMENT FOR AFTERNOON!!!
for fileIdx=1:length(NSxFiles)
    disp(NSxFiles(fileIdx).name);
    NSx = openNSx(fullfile(dataDir,NSxFiles(fileIdx).name),'read');
    allData = horzcat(allData,NSx.Data(1:16,:));
%     for j=1:16
%         allData(j,:) = [allData(j,:) NSx.Data(j,:)];
%     end
end

% L = 2*3e4; % Length of signal
% thresh = 1e4;
% chopSamples = L; %Xs @ 30kS/s
% pieces = findCleanSpans(allData,thresh,chopSamples);
% disp(['pieces:',num2str(length(pieces))]);

% % 20141125-105816-001.ns5
% % length:18033775
% % 20141125-105816-002.ns5
% % length:18038860
% % 20141125-105816-003.ns5
% % length:18038828
% % 20141125-105816-004.ns5
% % length:18038864
% % 20141125-105816-005.ns5
% % length:18038230
% % 20141125-105816-006.ns5
% % length:18038860
% % 20141125-105816-007.ns5
% % length:18038855
% % 20141125-105816-008.ns5
% % length:18038830
% % 20141125-105816-009.ns5
% % length:18038565
% % 20141125-105816-010.ns5
% % length:9304852
% % run_compileData
% % 20141125-152523-001.ns5
% % length:18046638
% % 20141125-152523-002.ns5
% % length:18039155
% % 20141125-152523-003.ns5
% % length:17420550