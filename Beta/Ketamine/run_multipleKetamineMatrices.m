beforeDir = uigetdir;
beforeFiles = dir(fullfile(beforeDir,'*.ns5'));

afterDir = uigetdir;
afterFiles = dir(fullfile(afterDir,'*.ns5'));

nsxFiles = [beforeFiles afterFiles];

filters = {'theta','4-8Hz_butter_30kHz.mat';
        'beta','13-30Hz_butter_30kHz.mat';
        'gamma','40-70Hz_butter_30kHz.mat'};

saveData = {};
for i=1:length(filters)
    [allMatrices,filePieces]=ketamineMatrix(nsxFiles,filters{i,2});
    
    %add up beforeFiles pieces
    ketamineLoc = 0;
    for j=1:length(beforeFiles)
        ketamineLoc = ketamineLoc+filePieces{j,2};
    end
    
    diffMatrix = dispKetamineMatrix(allMatrices,ketamineLoc,filters{i,1});
    saveData{i} = {allMatrices,filePieces,diffMatrix};
end