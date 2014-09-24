% (1) http://www.plexon.com/software-downloads
% (2) under the SDKs tab download the OmniPlex and MAP Offline SDK Bundle
% (3) extract the folders and add them to your Matlab path

% Ex1. write continuous data into .ddt file (for Offline Sorter)
% [errCode] = ddt_write_v(filename, nch, npoints, freq, d)
ddt_write_v(fullfile('C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data',...
    'starkDataSet01.ddt',1,length(data),3e4,data);
% after sorting, 'File > Export to New .PLX'