% beforeDir = uigetdir;
% beforeFiles = dir(fullfile(beforeDir,'*.ns5'));
% beforeFilenames = fileList(beforeDir,beforeFiles);
% 
% afterDir = uigetdir;
% afterFiles = dir(fullfile(afterDir,'*.ns5'));
% afterFilenames = fileList(afterDir,afterFiles);
% 
% nsxFiles = [beforeFilenames afterFilenames];

filters = {'theta','4-8Hz_butter_30kHz.mat';
        'beta','13-30Hz_butter_30kHz.mat';
        'gamma','40-70Hz_butter_30kHz.mat'};

saveData = {};
for i=1:length(filters)
    disp([filters{i,1},' filter']);
    [allMatrices,filePieces]=ketamineMatrix(nsxFiles,filters{i,2});
    
    %add up beforeFiles pieces
    ketamineLoc = 697; %account for indexing/length
%     for j=1:length(beforeFiles)
%         ketamineLoc = ketamineLoc+length(filePieces{j}{2});
%     end
    
    diffMatrix = dispKetamineMatrix(allMatrices,ketamineLoc,filters{i,1});
    saveData{i} = {allMatrices,filePieces,diffMatrix};
end