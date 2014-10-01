% openNSx('read');
% openNEV
% load zStruct
function run_betaGammaFingerPower(NS5,NEV,z,channel)
samples = 1e6;
runTime = samples/3e4; %seconds
% channel = 9;
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
meanBeta = normalize(smooth(mean(SnormB)));
smoothBeta = meanBeta;
%smoothBeta = smooth(meanBeta,15);
meanGamma = normalize(smooth(mean(SnormG)));
smoothGamma = meanGamma;
%smoothGamma = smooth(meanGamma,15);

xend = samples/3e4;
figure('position',[0,0,1200,900]);

subplot(4,1,1);
[nelements,centers] = hist(spikeVector,400);
bar(centers,nelements);
xlim([0 xend]);
title(strcat('Spikes Histogram (total:',num2str(length(spikeVector)),')'));
ylabel('spike count');
xlabel('Time (s)');

subplot(4,1,2);
fingerMaxIdx = find(ctimes<=1e6,1,'last');
fingerData = fingerVector(1:int32(runTime*1e3));
plot(runTime/length(fingerData):runTime/length(fingerData):runTime,fingerData,'color','k'); %s to ms
hold on;
plot(tB,smoothBeta,'b','LineWidth',3);
hold on;
plot(tG,smoothGamma,'r','LineWidth',3);

xlim([0 xend]);
title('Power');
ylabel('normalized power');
xlabel('Time (s)');
legend('Finger','Beta','Gamma');

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

suptitle(strcat('Channel:',num2str(channel)));

% New Figure
figure('position',[0,0,1200,900]);

subplot(2,1,1);
resampledFingerData = resample(fingerData,length(smoothBeta),length(fingerData));
plot(tB,resampledFingerData.*smoothBeta','LineWidth',3);
hold on;
plot(tB,repmat(mean(resampledFingerData.*smoothBeta'),size(resampledFingerData)),'--');
hold on;
plot(tG,resampledFingerData.*smoothGamma','r','LineWidth',3);
hold on;
plot(tG,repmat(mean(resampledFingerData.*smoothGamma'),size(resampledFingerData)),'--','color','r');;
xlim([0 xend]);
title('(Finger Flexon) x (Norm. Power)');
legend('Beta','mean','Gamma','mean');

subplot(2,1,2);
resampledBeta = resample(smoothBeta,length(nelements),length(smoothBeta));
resampledGamma = resample(smoothGamma,length(nelements),length(smoothGamma));
plot(centers,resampledBeta.*nelements','LineWidth',3);
hold on;
plot(centers,repmat(mean(resampledBeta.*nelements'),size(centers)),'--');
hold on;
plot(centers,resampledGamma.*nelements','r','LineWidth',3);
hold on;
plot(centers,repmat(mean(resampledGamma.*nelements'),size(centers)),'--','color','r');
xlim([0 xend]);
title('(Norm. Power) x (Spike Count)');
legend('Beta','mean','Gamma','mean');

suptitle(strcat('Channel:',num2str(channel)));