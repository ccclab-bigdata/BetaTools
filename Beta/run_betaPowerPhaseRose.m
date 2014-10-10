%plot(wavefilter(double(NS5.Data(1,1:100000)),5))
%

samples = 9e6;
channels = [11];
combinedSpikePhases = [];
unit = 2;
for i=1:length(channels) %REMOVE
    spikeTimes = [];
    allBeta = [];
    allSpikes = [];

    disp(strcat('channel:',num2str(channels(i))));
    
    data = double(NS5.Data(channels(i),1:samples));
    % performs high-pass wavelet filter, 5~=468Hz, see figure in docs
    HPdata = wavefilter(data,5);
    [allTimestamps,allSnippets,allIndices] = findEventTimes(NEV,channels(i),unit);
    spikeTimes = allTimestamps/3e4;
    
    % get spectogram data
    [t,f,Snorm] = spectogramData(data,[40 90]);
    % take average of Snorm matrix and normalize it to span 0-1
    meanBeta = normalize(mean(Snorm));
    smoothBeta = normalize(smooth(meanBeta,15));
    % set arbitrary threshold for trials
    threshold = 0;%mean(smoothBeta);%+std(smoothBeta);
    trialTimes = threshCrossTimes(smoothBeta,threshold);

    xend = samples/3e4;
    figure('position',[0,0,1200,900]);

    subplot(3,2,1);
    hist(spikeTimes,300);
    xlim([0 xend]);
    title('All Spikes Histogram');
    ylabel('spike count');
    xlabel('Time (s)');

    subplot(3,2,3);
    plot(t,meanBeta);
    hold on;
    plot(t,smoothBeta,'r');
    hold on;
    plot(t,repmat(threshold,[1 length(t)]),'-','color',[.5 .5 .5]);
    
    % optional gamma band
% %     [tg,fg,Snormg] = spectogramData(data,[30 70]);
% %     meanGamma = normalize(mean(Snormg));
% %     hold on; plot(t,meanGamma,'c');
    
    xlim([0 xend]);
    title('Beta Power');
    ylabel('normalized power');
    xlabel('Time (s)');
    legend('Beta','Smoothed','Thresh');

    subplot(3,2,5);
    imagesc(t,f,Snorm);
    xlim([0 xend]);
    title('Beta Spectrogram');
    ylabel('frequency');
    xlabel('Time (s)');

    % % figure;
    % % plot(meanBeta);
    % % hold on;
    % % for i=1:length(threshCrossTimes)
    % %     plot(threshCrossTimes{i},meanBeta(threshCrossTimes{i}),'r');
    % % end
    % % hold off;

    Hbp = bandpassFilt;
    spikePhases = [];
    maxSpikes = 0;
    for j=1:length(trialTimes)
        t1 = t(trialTimes{j}(1));
        t2 = t(trialTimes{j}(end));
        if(t1==t2),continue,end; %for single value entries, could fix in function itself
        trialData = extractdatac(data,3e4,[t1 t2]);
        trialDataBP = filter(Hbp,trialData);
        range = 0:3e4^-1:(3e4^-1)*(length(trialData)-1);
        % perform hilbert transform and extract params
        hx = hilbert(trialDataBP);
        instPhase = atan2(imag(hx),real(hx));
        %extract time-window of spikes, (x,x,1) zeros them to this trial
        spikeTimesSubset = extractdatapt(spikeTimes,[t1 t2],1); 
        
        % plot the longest trial
        if(length(spikeTimesSubset.times) > maxSpikes)
            hold off;
            subplot(3,2,2);
            plot(range',trialData,'g');
            hold on;
            plot(range',trialDataBP,'b');
            hold on;
            plot(spikeTimesSubset.times,trialDataBP(int32(spikeTimesSubset.times*3e4)),'.','color','k');
            ylim('auto')
            xlim([range(1) range(end)]);
            title(strcat('Beta Segment Ex., trial',num2str(j),'/',num2str(length(trialTimes))));
            ylabel('uV');
            xlabel('Trial Time (s)');
            legend('Raw','Beta LFP','Spikes');
            maxSpikes = length(spikeTimesSubset.times); %most spikes
        end
        spikePhases = vertcat(spikePhases,instPhase(int32(spikeTimesSubset.times*3e4)));
    end
    % log all spikePhases (used for multiple channels)
    combinedSpikePhases = vertcat(combinedSpikePhases,spikePhases);
    
    subplot(3,2,4);
    hist(rad2deg(spikePhases),50);
    xlim([-180 180]);
    title('Spike Phase Hist')
    xlabel('Degrees');

    subplot(3,2,6);
    rose(spikePhases);
    title('Spike Phase Rose');
    xlabel('Degrees');
    
    suptitle(strcat('Channel:',num2str(channels(i)),' Unit:',num2str(unit)));
end

% figure;
% rose(combinedSpikePhases);