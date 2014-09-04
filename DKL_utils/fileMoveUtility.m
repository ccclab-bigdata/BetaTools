%%

dirString = 'IM-163_DL-12';

startPath = fullfile('/Volumes','data drive',dirString,[dirString '_phaseDiffs']);
cd(startPath);

start_idx = 13;
temp = dir;
numElements = length(temp);
dirList = {};
fullPathList = {};
fileList = {};
full_fileList = {};
numDirs = 0;
numFiles = 0;
for i = 1 : numElements
    if isdir(temp(i).name)
        if strcmpi('.',temp(i).name) || strcmpi('..',temp(i).name)
            continue;
        end
        
        numDirs = numDirs + 1;
        fullPathList{numDirs} = fullfile(startPath, temp(i).name);
        dirList{numDirs} = temp(i).name;
    else
        if exist(temp(i).name,'file')
            numFiles = numFiles + 1;
            full_fileList{numFiles} = fullfile(startPath, temp(i).name);
            fileList{numFiles} = temp(i).name;
        end
    end
    
end

%%
for iFile = 1 : numFiles
    for iDir = 1 : numDirs
        if ~isempty(strfind(fileList{iFile}, dirList{iDir}))
            movefile(full_fileList{iFile}, fullPathList{iDir});
            continue;
        end
    end
end