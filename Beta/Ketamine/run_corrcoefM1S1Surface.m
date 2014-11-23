trials = 25; %30s
sampleStart = zNew(1,5).CerebusTimeStart; %see notes file
sampleStop = sampleStart+((trials*5000)/1000)*3e4; %5000 is the timeout
sampleLength = sampleStop-sampleStart;

% dataM1=NS4.Data(1:16,sampleStart:end);
% dataS1=NS4.Data(65:80,sampleStart:end);

dataM1=NS5.Data(1:16,sampleStart:sampleStart+3e6);
dataS1=NS5.Data(17:32,sampleStart:sampleStart+3e6);

usefilter = '40-70Hz_butter_30kHz.mat';
[phasesS1,filtDataS1] = extractBandpassPhase(dataS1,usefilter);
[phasesM1,filtDataM1] = extractBandpassPhase(dataM1,usefilter);

data = zeros(16,16);
for s1i=1:16
    for m1i=1:16
        [r,p] = corrcoef(phasesS1(s1i,:),phasesM1(m1i,:));
        data(s1i,m1i) = r(1,2);
    end
end
figure;
imagesc(data);
colorbar;
caxis([min(data(:)) max(data(:))]);
xlabel('M1');
ylabel('S1');
title('run002 gamma');