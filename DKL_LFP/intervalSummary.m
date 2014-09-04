function [signal] = intervalSummary(signal, threshold)

txtHeight = 15;
btnHeight = 20;
editHeight = 20;
lineSpace = 30;

curIntTxtLeft = 10;
curIntTxtBot = 350;
curIntTxtWidth = 100;

curIntEditLeft = curIntTxtLeft + curIntTxtWidth + 10;
curIntEditBot = curIntTxtBot - 2;
curIntEditWidth = 60;

markNoiseBtnLeft = curIntTxtLeft;
markNoiseBtnBot = curIntTxtBot - lineSpace;
markNoiseBtnWidth = 100;

markHVSBtnLeft = curIntTxtLeft;
markHVSBtnBot = markNoiseBtnBot - lineSpace;
markHVSBtnWidth = markNoiseBtnWidth;

unmarkNoiseBtnLeft = markNoiseBtnLeft + markNoiseBtnWidth + 20;
unmarkNoiseBtnBot = markNoiseBtnBot;
unmarkNoiseBtnWidth = 120;

unmarkHVSBtnLeft = markHVSBtnLeft + markHVSBtnWidth + 20;
unmarkHVSBtnBot = markHVSBtnBot;
unmarkHVSBtnWidth = unmarkNoiseBtnWidth;

GUIfig = figure('units', 'pixels');

h_curIntText = uicontrol('style','text', ...
                         'position', [curIntTxtLeft, curIntTxtBot, curIntTxtWidth, txtHeight], ...
                         'string', 'current interval:');
                     
                     
h_curIntEdit = uicontrol('style','Edit', ...
                         'position', [curIntEditLeft, curIntEditBot, curIntEditWidth, editHeight], ...
                         'callback', 'cb_currentInt');

h_markNoiseButton = uicontrol('style','pushbutton', ...
                              'position', [markNoiseBtnLeft, markNoiseBtnBot, markNoiseBtnWidth, btnHeight], ...
                              'string', 'Mark as Noise', ...
                              'callback', 'cb_markNoise');

h_markHVSbutton = uicontrol('style','pushbutton', ...
                            'position', [markHVSBtnLeft, markHVSBtnBot, markHVSBtnWidth, btnHeight], ...
                            'string', 'Mark as HVS', ...
                            'callback', 'cb_markHVS');

h_unmarkNoiseButton = uicontrol('style','pushbutton', ...
                              'position', [unmarkNoiseBtnLeft, unmarkNoiseBtnBot, unmarkNoiseBtnWidth, btnHeight], ...
                              'string', 'Unmark as Noise', ...
                              'callback', 'cb_unmarkNoise');

h_unmarkHVSbutton = uicontrol('style','pushbutton', ...
                            'position', [unmarkHVSBtnLeft, unmarkHVSBtnBot, unmarkHVSBtnWidth, btnHeight], ...
                            'string', 'Unmark as HVS', ...
                            'callback', 'cb_unmarkHVS');
                        
flag = 0;

ranges = threshold.interval_power_screen_ranges;
t = signal.t;
edgeTime = 0.05;
edgeSamples = round(signal.Fs * edgeTime);

% plot histogram of power ratios
start_indx = signal.prelim.start_indx;
end_indx = signal.prelim.end_indx;
durations = end_indx - start_indx;
nfft = 2 ^ nextpow2(max(durations));

numPrelimInts = length(start_indx);
power_ratio = zeros(1, numPrelimInts);
compareType = threshold.compareType;

compareString = [compareType '(Pxx(passband)) / ' compareType '(Pxx(stopbandranges))'];

for iInt = 1 : numPrelimInts
    
    [Pxx,f] = periodogram(detrend(signal.y(start_indx(iInt):end_indx(iInt))), ...
                          [], nfft, signal.Fs); %#ok<ASGLU>
    stopbandranges = [];
    for j = 1 : size(ranges, 1),
        stopbandranges = [stopbandranges find(f'>=ranges(j,1) & f'<=ranges(j,2))];
    end
    passband=(f>=threshold.filter.cutoff(2) & f<=threshold.filter.cutoff(3));
    
    
    power_ratio(iInt) = eval(compareString);
    
end

figure(4)
n = 0 : 0.2 : 10;
hist(power_ratio, n);


figure(1)
% plot the raw signal, overlaid with identified epochs
hold off
plot(t, signal.y,'k');
hold on
start_indx = signal.prelim.start_indx;
end_indx = signal.prelim.end_indx;
numIntervals = length(start_indx);
for iInt = 1 : numIntervals
    plot(t(start_indx(iInt):end_indx(iInt)), ...
         signal.y(start_indx(iInt):end_indx(iInt)), 'b');
end

start_indx = signal.final.start_indx;
end_indx = signal.final.end_indx;
numIntervals = length(start_indx);
for iInt = 1 : numIntervals
    plot(t(start_indx(iInt):end_indx(iInt)), ...
         signal.y(start_indx(iInt):end_indx(iInt)), 'r');
end


figure(2)
% plot power spectra for preliminary epochs (that is, epochs before
% elimination based on power ratio)
start_indx = signal.prelim.start_indx;
end_indx = signal.prelim.end_indx;

numIntervals = length(start_indx);
durations = end_indx - start_indx;
nfft = 2 ^ nextpow2(max(durations));

% keyboard;

for iInt = 1 : numIntervals
    disp(['Interval ' num2str(iInt)]);
    [Pxx,f] = periodogram(detrend(signal.y(start_indx(iInt):end_indx(iInt))), ...
                          [], nfft, signal.Fs);
    stopbandranges = [];
    for j = 1 : size(ranges, 1),
        stopbandranges = [stopbandranges find(f'>=ranges(j,1) & f'<=ranges(j,2))];
    end
    passband=(f>=threshold.filter.cutoff(2) & f<=threshold.filter.cutoff(3));
    
    power_ratio = eval(compareString);
    
    figure(2)
    hold off
    
    max_f = find(f > 60, 1, 'first');
    plot(f(1:max_f), Pxx(1:max_f));
    set(gcf,'name',['ratio = ' num2str(power_ratio)]);
    
    figure(1)
    set(gca,'xlim',[t(start_indx(iInt)) - edgeTime,t(end_indx(iInt)) + edgeTime]);
    
    figure(3)
    hold off
    lowLim = max(start_indx(iInt) - edgeSamples, 1);
    upLim = min(end_indx(iInt) + edgeSamples, length(signal.y));
    plot(t(lowLim:upLim), signal.yfilt(lowLim:upLim), 'k');
    hold on
    plot(t(start_indx(iInt):end_indx(iInt)), signal.yfilt(start_indx(iInt):end_indx(iInt)), 'b');
    line([t(lowLim) t(upLim)], [threshold.in_volts threshold.in_volts], 'color','k');
    set(gca,'xlim',[t(start_indx(iInt)) - edgeTime,t(end_indx(iInt)) + edgeTime]);
    

    keyboard;
%     user_in = input('[c]ontinue or [s]kip to final intervals: ', 's');
    if flag
        break;
    end
end

flag = 0;
figure(2)
% plot power spectra for final epochs (that is, epochs after
% elimination based on power ratio)
start_indx = signal.final.start_indx;
end_indx = signal.final.end_indx;

numIntervals = length(start_indx);
durations = end_indx - start_indx;
nfft = 2 ^ nextpow2(max(durations));

for iInt = 1 : numIntervals
    disp(['Interval ' num2str(iInt)]);
    [Pxx,f] = periodogram(detrend(signal.y(start_indx(iInt):end_indx(iInt))), ...
                          [], nfft, signal.Fs);
    stopbandranges = [];
    for j = 1 : size(ranges, 1),
        stopbandranges = [stopbandranges find(f'>=ranges(j,1) & f'<=ranges(j,2))];
    end
    passband=(f>=threshold.filter.cutoff(2) & f<=threshold.filter.cutoff(3));
    
    power_ratio = eval(compareString);
                      
    figure(2)
	hold off
    max_f = find(f > 60, 1, 'first');
    plot(f(1:max_f), Pxx(1:max_f));
    set(gcf,'name',['ratio = ' num2str(power_ratio)]);
    
    figure(1)
    set(gca,'xlim',[t(start_indx(iInt)) - edgeTime,t(end_indx(iInt)) + edgeTime]);
        figure(3)
    hold off
    lowLim = min(start_indx(iInt) - edgeSamples, 1);
    upLim = max(end_indx(iInt) + edgeSamples, length(signal.y));
    plot(t(lowLim:upLim), signal.yfilt(lowLim:upLim));
    hold on
    plot(t(start_indx(iInt):end_indx(iInt)), signal.yfilt(start_indx(iInt):end_indx(iInt)), 'r');
    set(gca,'xlim',[t(start_indx(iInt)) - edgeTime,t(end_indx(iInt)) + edgeTime]);
    line([t(lowLim) t(upLim)], [threshold.in_volts threshold.in_volts], 'color','k');
    
    keyboard;
    
%     user_in = input('[c]ontinue or [e]nd: ', 's');
    if flag
        break;
    end
end
