function intervalSummary2(intStruct, channel)

if isempty(intStruct)
    disp('Interval structure for this channel is empty.')
    return;
end

b = intStruct.threshold.filter.b;
a = intStruct.threshold.filter.a;


defaultDrive = fullfile('/Volumes','data drive');
%     defaultDrive = '';

LFPfn = channel.files.lfp.file;
[~, fn, ext, ~] = fileparts(LFPfn);

if ~isempty(defaultDrive)
    if exist([fn ext], 'file')
        LFPfn = which([fn ext]);
    end
end

wireNum = getRepWire(channel);
if ~wireNum
    disp('no good wires for this channel');
    return;
end

signal = initSignal(LFPfn, wireNum);
if size(signal.y, 1) > 1
    signal.y = signal.y';
end

signal.yfilt = filtfilt(b, a, signal.y);
signal.final = intStruct.final;
signal.prelim = intStruct.prelim;

intervalSummary(signal, intStruct.threshold)