startTrial = 5;
runStart = 1;%zNew(1,startTrial).CerebusTimeStart;
t=[];
ii=1;
for i=startTrial:1000
    disp(i);
    sampleStart = runStart+((i*5000)/1000)*3e4;
    sampleStop = sampleStart+((trials*5000)/1000)*3e4;
    if(length(NS4.Data)<sampleStop)
        break;
    end

%     dataM1=NS5.Data(1:16,sampleStart:sampleStop);
%     dataS1=NS5.Data(17:32,sampleStart:sampleStop);
    dataM1=NS4.Data(1:16,sampleStart:sampleStop);
    dataS1=NS4.Data(65:80,sampleStart:sampleStop);
    
    [phasesS1,filtDataS1] = extractBandpassPhase(dataS1);
    [phasesM1,filtDataM1] = extractBandpassPhase(dataM1);

    meanPhasesS1=mean(phasesS1);
    meanPhasesM1=mean(phasesM1);
    [r,p]=corrcoef(meanPhasesS1,meanPhasesM1);

    t(ii)=r(1,2);
    ii=ii+1;
end

rbeta=t;
figure;
plot(rbeta);