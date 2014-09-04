function signal = initSignal(fn, wireNum)
%
% function to initiate a signal structure for use in extracting periods of
% LFP oscillations
%
% usage: signal = initSignal(fn, wireNum)

voltRange = [-10 10]; % max and min voltages on the DAQ card

if ~exist(fn, 'file') || wireNum == 0
    disp([fn ' does not exist.']);
    
    signal.y = [];
    signal.yfilt = [];
    signal.t = [];
    signal.Fs = [];
    signal.satVolt = [];
    signal.final.start_indx = [];
    signal.final.end_indx = [];
    signal.prelim.start_indx = [];
    signal.prelim.end_indx = [];
    signal.fused.start_indx = [];
    signal.fused.end_indx = [];
    signal.filter.cufoff = [];
    signal.filter.b = [];
    signal.filter.a = 1;
    
    signal.firstIntervals.start_indx = [];
    signal.firstIntervals.end_indx = [];

    signal.noiseIntervals.start_indx = [];
    signal.noiseIntervals.end_indx = [];
    
    signal.HVS.start_indx = [];
    signal.HVS.end_indx = [];
    
    signal.trials.start_indx = [];
    signal.trials.end_indx = [];
    
    signal.LFPfn = '';
    signal.chName = '';
   
    return;
end

lfpHeader = getHSDHeader(fn);
chInfo = getChannelInfoFromHeader( lfpHeader, wireNum );

if isempty(chInfo)    % wireNum does not exist in this file
    disp([num2str(wireNum) ' does not exist in file ' fn '.']);
    
    signal.y = [];
    signal.yfilt = [];
    signal.t = [];
    signal.Fs = [];
    signal.satVolt = [];
    signal.final.start_indx = [];
    signal.final.end_indx = [];
    signal.prelim.start_indx = [];
    signal.prelim.end_indx = [];
    signal.fused.start_indx = [];
    signal.fused.end_indx = [];
    signal.filter.cufoff = [];
    signal.filter.b = [];
    signal.filter.a = 1;
    
    signal.firstIntervals.start_indx = [];
    signal.firstIntervals.end_indx = [];

    signal.noiseIntervals.start_indx = [];
    signal.noiseIntervals.end_indx = [];
    
    signal.HVS.start_indx = [];
    signal.HVS.end_indx = [];
    
    signal.trials.start_indx = [];
    signal.trials.end_indx = [];
    
    signal.LFPfn = '';
    signal.chName = '';
   
    return;
end

if isfield(lfpHeader.main, 'downsampled_rate')
    if lfpHeader.main.downsampled_rate < 100
        Fs = lfpFs(lfpHeader);
    else
        Fs = lfpHeader.main.downsampled_rate;
    end
else
    Fs = lfpFs(lfpHeader);
end

disp('loading signal');
signal.y = readSingleWire(fn, wireNum);
disp('signal loaded');
signal.y = int2volt(signal.y, 'gain', chInfo.gain, 'range', voltRange);
signal.yfilt = [];
signal.t = linspace(0, length(signal.y) / Fs, length(signal.y));
signal.Fs = Fs;
signal.satVolt = voltRange(2) / chInfo.gain * 1000;  % saturation potential in mv
signal.final.start_indx = [];
signal.final.end_indx = [];
signal.prelim.start_indx = [];
signal.prelim.end_indx = [];
signal.fused.start_indx = [];
signal.fused.end_indx = [];
signal.filter.cufoff = [];
signal.filter.b = [];
signal.filter.a = 1;

signal.firstIntervals.start_indx = [];
signal.firstIntervals.end_indx = [];

signal.noiseIntervals.start_indx = [];
signal.noiseIntervals.end_indx = [];

signal.HVS.start_indx = [];
signal.HVS.end_indx = [];

signal.trials.start_indx = [];
signal.trials.end_indx = [];

signal.LFPfn = fn;
signal.chName = '';