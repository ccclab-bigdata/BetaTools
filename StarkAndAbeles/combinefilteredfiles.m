function [ data,time ] = combinefilteredfiles(low, high, filename)
%function [ data,time ] = combinefilteredfiles(low, high)
%   Combinefilteredfiles just gives you an array where each column was the
%   data from a single datafile (indicated by "filtered" in the filename).
%   Must be run in the directory with the filtered files if path not included.
if(nargin==0)
    list = dir('*filtered.mat');
elseif (nargin < 3)
    list = dir(['*filtered' num2str(low) 'to' num2str(high) '.mat']);
elseif (nargin == 3)
    [filepath, filename] = fileparts(filename);
    list = dir(fullfile(filepath, [filename '*filtered' num2str(low) 'to' num2str(high) '.mat']));
end


for i = 1:length(list)
    load(fullfile(filepath, list(i).name),'Data');
    if(i==1)
        data = zeros(length(Data),length(list)); %#ok<NODEF> -loaded from file
    end
    data(:,i) = Data(:);
end

time = 1:size(data,1);
time = (time-1)*60+31;
