[f,p] = uigetfile('*');
fileID = fopen(fullfile(p,f));
binData = fread(fileID,Inf,'double');
fclose(fileID);