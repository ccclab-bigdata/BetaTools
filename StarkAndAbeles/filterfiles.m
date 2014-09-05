function filterfiles(filename,lower,upper)
% filterfiles just reads in each channel file from the .mats created by
% splitfile, defaulting to a base filename of sensorytasklateral003.ns5.
% Then it applies S&A-style MUA calculations to each channel, and saves the
% result in a separate file.

if(nargin==0 || isempty(filename))
    filename = 'sensorytasklateral003';
end

if(nargin < 2)
    lower = 300;
end

if(nargin < 3)
    upper = 6000;
end

[filepath, filename] = fileparts(filename);

tic;
for i = 1:96
    disp(['Starting file ' num2str(i)])
    chfile = fullfile(filepath, [filename 'channel' num2str(i)]);
    load(chfile);
    Data = double(Data);
    Data = SAFilter(Data,lower,upper);
    disp(['Filtered file ' num2str(i)])
    Data = SAClip(Data);
    disp(['Clipped file ' num2str(i)])
    Data = SARMS(Data);    
    disp(['RMS completed on file ' num2str(i)])
    toc
    if(i < 10)
        chfile = [chfile(1:end-1) '0' chfile(end)];
    end
    
    save([chfile 'filtered' num2str(lower) 'to' num2str(upper)],'Data') 
end