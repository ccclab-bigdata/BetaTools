function dirList = extractDirs(pathList)
%
% usage: dirList = extractDirs(pathList)
%
% INPUTS:
%   pathList - standard matlab file/directory attributes structure
%
% OUTPUTS:
%   dirList - standard matlab file/directory attributes structure
%       containing only directories in pathList

numPaths = length(pathList);
numDirs  = 0;

fnames = fieldnames(pathList(1));
initStructString = '';
for iField = 1 : length(fnames)
    if iField == 1
        initStructString = sprintf('''%s'',{}', fnames{iField});
    else
        initStructString = [initStructString ',' sprintf('''%s'',{}', fnames{iField})];
    end
end
% emptyCell = cell(length(fnames), 1);
% initStructCells = [fnames, emptyCell];
% initStructCells = reshape(initStructCells',1,length(fnames)*2);
dirList = eval(['struct(' initStructString ');']);
for iPath = 1 : numPaths
    
    if pathList(iPath).isdir
        
        numDirs = numDirs + 1;
        dirList(numDirs) = pathList(iPath);
        
    end
    
end