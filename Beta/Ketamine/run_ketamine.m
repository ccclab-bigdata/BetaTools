zNew=SyncZNEV(z,1,1); %change for different runs!
trials = 6;
sampleStart = zNew(1,5).CerebusTimeStart; %see notes file
sampleStop = sampleStart+((trials*5000)/1000)*3e4; %5000 is the timeout
sampleLength = sampleStop-sampleStart;

dataM1=NS4.Data(1:16,sampleStart:sampleStop);
dataS1=NS4.Data(65:80,sampleStart:sampleStop);

% dataM1=NS5.Data(1:16,sampleStart:sampleStop);
% dataS1=NS5.Data(17:32,sampleStart:sampleStop);

[phasesS1,filtDataS1] = extractBandpassPhase(dataS1);
[phasesM1,filtDataM1] = extractBandpassPhase(dataM1);

% load('fmaArrayMap.mat');

phaseMapS1 = applyPhaseToMap(phasesS1,fmaArrayMap);
phaseMapM1 = applyPhaseToMap(phasesM1,fmaArrayMap);

contourPhases(phaseMapS1,phaseMapM1);