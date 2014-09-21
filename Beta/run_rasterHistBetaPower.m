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
    HPdata = wavefilter(data,5);
    locs = absPeakDetection(HPdata);
    spikeVector = locs*(3e4^-1);
    %spikeVector = horzcat(spikeVector,allSpikes);
    
    [t,sinFit,Snorm]=betaspec(data);
    cSnorm = normalize(mean(Snorm)); %normalized(0-1)-compressed Snorm
    %allBeta(i,:) = cSnorm(1,:);

    meanBeta = mean(cSnorm,1);
    threshold = mean(smoothData)+std(smoothData); %arbitrary
    smoothAmt = 5;

    xend = samples/3e4;
    figure;
    % subplot(4,1,1);
    % plotSpikeRaster(allSpikes');
    % xlim([0 xend]);
    % title('All Spikes Raster');
    % ylabel('channel');

    subplot(3,2,1);
    hist(spikeVector,200);
    xlim([0 xend]);
    title('All Spikes Histogram');
    ylabel('spike count');
    xlabel('Time (s)');

    subplot(3,2,3);
    plot(t,meanBeta);
    hold on;
    plot(t,smooth(meanBeta,smoothAmt),'r');
    hold on;
    plot(t,repmat(threshold,[1 length(t)]),'-','color',[.5 .5 .5]);
    xlim([0 xend]);
    title('Beta Power (13-30Hz)');
    ylabel('normalized power');
    xlabel('Time (s)');
    legend('Beta','Smoothed','Thresh');

    subplot(3,2,5);
    imagesc(t,sinFit,Snorm);
    xlim([0 xend]);
    title('Beta Spectrogram (13-30Hz)');
    ylabel('frequency');
    xlabel('Time (s)');

    %xlabel(strcat('time (s)--','channel:',num2str(channels(i))));

    threshCrossTimes = getThreshCrossTimes(meanBeta,smoothAmt,threshold); %thresh set in function

    % % figure;
    % % plot(meanBeta);
    % % hold on;
    % % for i=1:length(threshCrossTimes)
    % %     plot(threshCrossTimes{i},meanBeta(threshCrossTimes{i}),'r');
    % % end
    % % hold off;

    %[b,a]=butter(4,2*30*2/3e4,'low'); %how to do bandpass of 13-30?
    Hbp = bandpassFilt;
    spikePhases = [];
    deltat = 0;
    for j=1:length(threshCrossTimes)
        t1 = t(threshCrossTimes{j}(1));
        t2 = t(threshCrossTimes{j}(end));
        if(t1==t2),continue,end; %for single value entries, could fix in function itself
        trialData = extractdatac(data,3e4,[t1 t2]);
        trialDataLP = filter(Hbp,trialData);
        range = 0:3e4^-1:(3e4^-1)*(length(trialData)-1);
        sinFit = fit(range',trialDataLP,'sin1');

        amplitude = sinFit.a1;
        w = sinFit.b1; %/(2*pi)
        phi = sinFit.c1; %rad2deg()

        spikes = extractdatapt(spikeVector,[t1 t2],1); %(x,x,1) zeros them to this trial
        
        % plot one example
        if(t2-t1 > deltat)
            hold off;
            subplot(3,2,2);
            plot(range',trialData,'g');
            hold on;
            plot(sinFit,range',trialDataLP,'b');
            hold on;
            plot(spikes.times,amplitude*sin(spikes.times*w+phi),'.','color','k');
            ylim('auto')
            xlim([range(1) range(end)]);
            legend('Raw','13-30Hz','Sine Fit','Spikes');
            title(strcat('Beta Segment Ex., trial',num2str(j)));
            ylabel('uV');
            xlabel('Trial Time (s)');
        end
        
        for k=1:length(spikes.times)
            spikePhase = atan2(sin(w*spikes.times(k)+phi),cos(w*spikes.times(k)+phi));
            spikePhases = horzcat(spikePhases,spikePhase);
        end
        deltat = t2-t1;
    end
%     figure;
%     rose(spikePhases);
%     title(strcat('channel:',num2str(channels(i))));
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