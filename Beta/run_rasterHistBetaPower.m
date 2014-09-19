%plot(wavefilter(double(NS5.Data(1,1:100000)),5))
%
samples = 1e6;
spikeVector = [];
allBeta = [];
allSpikes = [];
for i=1:96
    disp(i);
    data = double(NS5.Data(i,1:samples));
    HPdata = wavefilter(data,5);
    peaks = findpeaks(abs(HPdata),400);
    allSpikes{i} = peaks.loc'*(params.Fs^-1);
    spikeVector = horzcat(spikeVector,allSpikes{i});
    
    [t,f,Snorm]=betaspec(data);
    cSnorm = normalize(mean(Snorm)); %normalized(0-1)-compressed Snorm
    allBeta(i,:) = cSnorm(1,:);
end
meanBeta = mean(allBeta);

xend = samples/params.Fs;
figure;

subplot(4,1,1);
plotSpikeRaster(allSpikes');
xlim([0 xend]);
title('All Spikes Raster');
ylabel('channel');

subplot(4,1,2);
hist(spikeVector,500);
xlim([0 xend]);
title('All Spikes Histogram (500 bins)');
ylabel('spike count');

subplot(4,1,3);
plot(t,meanBeta);
xlim([0 xend]);
title('Beta Power (13-30Hz)');
ylabel('normalized power');

subplot(4,1,4);
imagesc(t,f,Snorm);
xlim([0 xend]);
title('Beta Spectrogram (13-30Hz)');
ylabel('frequency');

xlabel('time (s)');