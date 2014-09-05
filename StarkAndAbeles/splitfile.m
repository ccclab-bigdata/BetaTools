function splitfile(filename)
% Splitfile just reads in each channel from a ns5 file (defaults to
% sensorytasklateral003.ns5, but filename can be given as an argument), and
% saves it to a separate file.

if(nargin==0)
    filename = 'sensorytasklateral003.ns5';
end

for i = 1:96
    data = openNSx('read',filename,['c:' num2str(i)]);
    [filepath,savename] = fileparts(filename);
    %save([savename 'channel' num2str(i)],'-struct','data','Data') 
    save(fullfile(filepath, [savename 'channel' num2str(i)]),'-struct','data','Data') 
end