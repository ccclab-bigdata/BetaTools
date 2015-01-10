% SyncZNEV(Z, run, startRun, NEVdir)
zNew=SyncZNEV(z,2,1);
trials = 20;
sampleStart = zNew(1,5).CerebusTimeStart; %see notes file
sampleStop = sampleStart+((trials*5000)/1000)*3e4; %5000 is the timeout
sampleLength = sampleStop-sampleStart;
% find proper NSx from zNew > openNSx('read')
dataM1=NS4.Data(1:16,sampleStart:sampleStop);
dataS1=NS4.Data(65:80,sampleStart:sampleStop);

dataM1=NS5.Data(1:16,sampleStart:sampleStop);
dataS1=NS5.Data(17:32,sampleStart:sampleStop);

[phasesS1,filtDataS1] = extractBandpassPhase(dataS1,'13-30Hz_butter_10kHz.mat');
[phasesM1,filtDataM1] = extractBandpassPhase(dataM1,'13-30Hz_butter_10kHz.mat');

meanPhasesS1=mean(phasesS1);
meanPhasesM1=mean(phasesM1);
[r,p]=corrcoef(meanPhasesS1,meanPhasesM1);
% load('fmaArrayMap.mat');

phaseMapS1 = applyPhaseToMap(phasesS1,fmaArrayMap);
phaseMapM1 = applyPhaseToMap(phasesM1,fmaArrayMap);

contourPhases(phaseMapS1,phaseMapM1);