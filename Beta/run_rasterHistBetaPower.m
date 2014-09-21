%plot(wavefilter(double(NS5.Data(1,1:100000)),5))
%
samples = 1e6;
channels = 9;
combinedSpikePhases = [];
for i=1:length(channels)
    spikeVector = [];
    allBeta = [];
    allSpikes = [];

    disp(strcat('channel:',num2str(channels(i))));
    data = double(NS5.Data(channels(i),1:samples));
    % performs high-pass wavelet filter, 5~=468Hz, see figure in docs
    HPdata = wavefilter(data,5);
    % extract peaks based on absolute value threshold
    locs = absPeakDetection(HPdata);
    % convert peak location to actual spike times
    spikeVector = locs/3e4;
    
    % get spectogram data
    [t,f,Snorm] = spectogramData(data,[13 30]);
    % take average of Snorm matrix and normalize it to span 0-1
    meanBeta = normalize(mean(Snorm));
    smoothBeta = smooth(meanBeta,15);
    % set arbitrary threshold for trials
    threshold = mean(smoothBeta)+std(smoothBeta);
    trialTimes = threshCrossTimes(smoothBeta,threshold);

    xend = samples/3e4;
    figure;

    subplot(3,2,1);
    hist(spikeVector,200);
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
    title('Beta Power (13-30Hz)');
    ylabel('normalized power');
    xlabel('Time (s)');
    legend('Beta','Smoothed','Thresh');

    subplot(3,2,5);
    imagesc(t,f,Snorm);
    xlim([0 xend]);
    title('Beta Spectrogram (13-30Hz)');
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
    deltat = 0;
    for j=1:length(trialTimes)
        t1 = t(trialTimes{j}(1));
        t2 = t(trialTimes{j}(end));
        if(t1==t2),continue,end; %for single value entries, could fix in function itself
        trialData = extractdatac(data,3e4,[t1 t2]);
        trialDataBP = filter(Hbp,trialData);
        range = 0:3e4^-1:(3e4^-1)*(length(trialData)-1);
        % fit single sine wave to data
        sinFit = fit(range',trialDataBP,'sin1');
        amplitude = sinFit.a1;
        w = sinFit.b1; %/(2*pi)
        phi = sinFit.c1; %rad2deg()
        % extract spike times from trial window
        spikes = extractdatapt(spikeVector,[t1 t2],1); %(x,x,1) zeros them to this trial
        
        % plot the longest trial
        if(t2-t1 > deltat)
            hold off;
            subplot(3,2,2);
            plot(range',trialData,'g');
            hold on;
            plot(sinFit,range',trialDataBP,'b');
            hold on;
            plot(spikes.times,amplitude*sin(spikes.times*w+phi),'.','color','k');
            ylim('auto')
            xlim([range(1) range(end)]);
            legend('Raw','13-30Hz','Sine Fit','Spikes');
            title(strcat('Beta Segment Ex., trial',num2str(j)));
            ylabel('uV');
            xlabel('Trial Time (s)');
        end
        
        % calculate spike phase using atan2 and sin/cos components
        for k=1:length(spikes.times)
            spikePhase = atan2(sin(w*spikes.times(k)+phi),cos(w*spikes.times(k)+phi));
            spikePhases = horzcat(spikePhases,spikePhase);
        end
        deltat = t2-t1;
    end
    % log all spikePhases (used for multiple channels)
    combinedSpikePhases = horzcat(combinedSpikePhases,spikePhases);
    
    subplot(3,2,4);
    hist(rad2deg(combinedSpikePhases));
    xlim([-180 180]);
    title('Spike Phase Hist')
    xlabel('Degrees');

    subplot(3,2,6);
    rose(combinedSpikePhases);
    title('Spike Phase Rose');
    xlabel('Degrees');
    
    [ax,h3]=suplabel(strcat('Channel',num2str(channels(i))),'t');
    set(h3,'FontSize',18);
end

% figure;
% rose(combinedSpikePhases);