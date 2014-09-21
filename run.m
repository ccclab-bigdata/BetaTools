% data = NS5.Data(1,1:1000000);
% peaksLoc = absPeakDetection(data);
% 
% spikes = [];
% for i=1:length(peaksLoc)
%     spikes(i,:) = data(1,peaksLoc(i)-16:peaksLoc(i)+16);
% end

% figure;
% plot(spikes','b');

thresh = mean(meanBeta) + std(meanBeta);
threshCrossTimes = getThreshCrossTimes(meanBeta,thresh);

% % figure;
% % plot(meanBeta);
% % hold on;
% % for i=1:length(threshCrossTimes)
% %     plot(threshCrossTimes{i},meanBeta(threshCrossTimes{i}),'r');
% % end
% % hold off;

[b,a]=butter(4,2*30*2/3e4,'low'); %how to do bandpass of 13-30?
spikePhases = [];
for i=1:length(threshCrossTimes)
    t1 = t(threshCrossTimes{i}(1));
    t2 = t(threshCrossTimes{i}(end));
    if(t1==t2),continue,end;
    trialData = extractdatac(data,3e4,[t1 t2]);
    range = 0:3e4^-1:(3e4^-1)*(length(trialData)-1);
    trialDataLP = filtfilt(b,a,trialData);
    %figure;
    %could do FFT, look for peaks, dont know how to align though
    f = fit(range',trialDataLP,'sin2');
    %plot(f,range',trialDataLP);
    if(f.b1/(2*pi) > 13 && f.b1/(2*pi) < 30)
        amplitude = f.a1;
        frequency = f.b1; %/(2*pi)
        phase = f.c1; %rad2deg()
    elseif(f.b2/(2*pi) > 13 && f.b2/(2*pi) < 30)
        amplitude = f.a2;
        frequency = f.b2;
        phase = f.c2;
    else
        disp('no beta sine found!');
        continue; %handle better
    end
    
    spikes = extractdatapt(spikeVector,[t1 t2],1); %(x,x,1) zeros them to this trial
    %hold on;plot(spikeTimes.times,zeros(1,length(spikeTimes.times)),'o');
    f = frequency/(2*pi);
    
    for j=1:length(spikes.times)
        adjTime = mod(spikes.times(j),1/f);
        spikePhase = 360*f*(adjTime+(phase/frequency));
        if(spikePhase < 0)
            spikePhase = 360+spikePhase;
        end
        spikePhases = horzcat(spikePhases,spikePhase);
    end
end
figure;
rose(deg2rad(spikePhases(:)));


