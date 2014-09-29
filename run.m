% openNSx('read');
% openNEV
% load zStruct

samples = 1e6;
runTime = samples/3e4; %seconds
channel = 6;
combinedSpikePhases = [];

spikeVector = [];
allBeta = [];
allSpikes = [];

[etimes,ctimes,~] = FixCerebusTimes(NEV);
fingerVector = makeFingerVector(z);

disp(strcat('channel:',num2str(channel)));
data = double(NS5.Data(channel,1:samples));
% performs high-pass wavelet filter, 5~=468Hz, see figure in docs
HPdata = wavefilter(data,5);
% extract peaks based on absolute value threshold
locs = absPeakDetection(HPdata);
% convert peak location to actual spike times
spikeVector = locs/3e4;

% get spectogram data
[tB,fB,SnormB] = spectogramData(data,[17 40]);
[tG,fG,SnormG] = spectogramData(data,[40 90]);
% take average of Snorm matrix and normalize it to span 0-1
meanBeta = normalize(mean(SnormB));
smoothBeta = smooth(meanBeta,15);
meanGamma = normalize(mean(SnormG));
smoothGamma = smooth(meanGamma,15);

xend = samples/3e4;
figure('position',[0,0,1200,900]);

subplot(4,1,1);
hist(spikeVector,400);
xlim([0 xend]);
title('All Spikes Histogram');
ylabel('spike count');
xlabel('Time (s)');

subplot(4,1,2);
fingerMaxIdx = find(ctimes<=1e6,1,'last');
fingerData = fingerVector(1:int32(runTime*1e3));
plot(runTime/length(fingerData):runTime/length(fingerData):runTime,fingerData,'k'); %s to ms
hold on;
plot(tB,smoothBeta,'b','LineWidth',4);
hold on;
plot(tG,smoothGamma,'r','LineWidth',4);

xlim([0 xend]);
title('Power');
ylabel('normalized power');
xlabel('Time (s)');
legend('Finger','Beta 13-30Hz','Gamma 30-90Hz');

subplot(4,1,3);
imagesc(tB,fB,SnormB);
xlim([0 xend]);
title('Beta 13-30Hz');
ylabel('frequency');
xlabel('Time (s)');

subplot(4,1,4);
imagesc(tG,fG,SnormG);
xlim([0 xend]);
title('Gamma 30-90Hz');
ylabel('frequency');
xlabel('Time (s)');
