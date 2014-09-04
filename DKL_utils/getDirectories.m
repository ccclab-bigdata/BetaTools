function dirList = getDirectories(filepath)
%
% function to get a list of all directories within the specified filepath
%
% usage: dirList = getDirectories(filepath)
%
% INPUTS:
%   filepath - path within which to look for directories
%
% OUTPUTS:
%   dirList - list of directories within filepath; returned as the standard
%       structure retuned by 'dir'. This excludes the '.' and '..' paths

startPath = pwd;
cd(filepath);

temp = dir;
numDirs = length(temp);

numValidDirs = 0;
for iDir = 1 : numDirs
    
    if temp(iDir).isdir && ~strcmp(temp(iDir).name, '.') && ~strcmp(temp(iDir).name, '..')
        numValidDirs = numValidDirs + 1;
        dirList(numValidDirs) = temp(iDir);
    end
    
end

cd(startPath);

end