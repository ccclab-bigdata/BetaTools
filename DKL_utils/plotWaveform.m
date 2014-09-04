function wvArray = getWaveforms...
    ( unit_to_plot, unitIdx, ts, varargin )

% function to plot a waveform given the unit index(es) and arrays of unit
% indices and timestamps. The variable arguments are for a file name

% input arguments:
%   unit_to_plot - the index of the unit to plot
%   unitIdx - vector of unit indices that correspond to timestamps
%   ts - timestamps for each waveform (in seconds)

%   'filename' - the name of the associated .hsd/.hsdw file
%   'numbertoplot' - the number of waveforms to plot
%   'plotwindow' - the time (in ms) before and after the timestamp to
%       plot (1 x 2 array)
%   'fs' - the sampling rate of the .hsd/.hsdw file (default 31250 Hz)
%   'dataoffset' - the data offset added by the header (if present)
%   'numwires' - the number of wires recorded in the .hsd/.hsdw file
%   'wirestosave' - indices of the wires to store

fn = '';
ntp = 0;
Fs = 31250;
dataType = 'int16';
wires_to_save = [];
plotWindow = [-.3 0.7];
numWires = 4;
dataOffset = 0;
wires_to_save = [1 : 4];

defaultPath = '/Volumes/dan/Recording data/IM-164_DL-22/IM-164_DL-22_hsd';

for iarg = 5 : 2 : nargin
    
    switch lower(varargin{iarg})
        
        case 'filename',
            fn = varargin{iarg + 1};
            fullName = fn;
            
        case 'numbertoplot',
            ntp = varargin{iarg + 1};
            
        case 'plotwindow',
            plotWindow = varargin{iarg + 1};
            
        case 'fs',
            Fs = varargin{iarg + 1};
            
        case 'datatype',
            dataType = varargin{iarg + 1};
            
        case 'dataoffset',
            dataOffset = varargin{iarg + 1};
            
        case 'numwires',
            numWires = varargin{iarg + 1};
            
        case 'wirestosave',
            wires_to_save = varargin{iarg + 1};
            
    end    % end switch
    
end    % end for iarg...

if isempty(fn)
    cd(defaultPath)

    [fn, pn, FilterIndex] = uigetfile({'*.hsdw'; '*.hsd'});

    fullName = [pn filesep fn];
    
end    % end if isempty(fn)


bytes_per_sample = getBytesPerSample( dataType );
plotWindow = plotWindow / 1000;
idx = find(unitIdx == unit_to_plot);

if or(ntp == 0, ntp > length(idx))
    ntp = length(idx);
    wvIdx = idx;
else
    n = randperm(length(idx));
    wvIdx = n(1 : length(idx));
end

samples_pre = floor(plotWindow(1) * Fs);
samples_post = floor(plotWindow(2) * Fs);
wvWidth = samples_pre + samples_post;

wvArray = zeros(ntp, length(wires_to_save), wvWidth);

fid = fopen(fullName, 'r');

for iWv = 1 : ntp
    
    timeLimits = plotWindow + ts(wvIdx);
    startSample = Fs * timeLimits(1);
    startPosition = dataOffset + startSample * numWires * bytes_per_sample;
    fseek(fid, startPosition, 'bof');
    
    [rawData, num_read] = fread(fid, [numWires, wvWidth], dataType);
    
    wvArray(iWv, :, :) = rawData(wires_to_save, :);
    
end    % enf for iWv

fclose(fid);
    
    