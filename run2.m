% sampleStart = zNew(1,1).CerebusTimeStart;
% sampleStop = zNew(1,end).CerebusTimeStop;
% meanSnorm = [];
% for i=1:16:channels %just get representative values
%     disp(i);
%     data = NS5.Data(i,sampleStart:sampleStop);
%     [t,f,Snorm] = spectogramData(data,[13 30]);
%     if(i==1)
%         meanSnorm = Snorm;
%     else
%         meanSnorm = (meanSnorm+Snorm)/2;
%     end
% end
% 
% meanSnormUpsample = [];
% for i=1:size(meanSnorm,1)
%     meanSnormUpsample(i,:) = interp1(1:length(meanSnorm),meanSnorm(i,:),linspace(1,length(meanSnorm),length(data)));
% end
% meanBeta = mean(meanSnormUpsample);

%[ ]Remove extra NEV files and rerun zNew function
moveThresh = 6e-5;
stillThresh = 1e-5;
allMovePower = [];
allStillPower = [];
for i=1:72%length(zNew)
    sampleStart = zNew(1,i).CerebusTimeStart;
    sampleStop = zNew(1,i).CerebusTimeStop;
    disp((sampleStop-sampleStart)/3e4);
    [fingerAngles,pos]=avgFingerAngles(zNew(1,i));
    %fingerAnglesDigital = round(fingerAngles);
    fingerAnglesUpsample = interp1(1:length(fingerAngles),fingerAngles(:),linspace(1,length(fingerAngles),sampleStop-sampleStart));
    diffFAU = diff(smooth(fingerAnglesUpsample,500));
    idxFAUmove = find(abs(diffFAU)>=moveThresh);
    idxFAUstill = find(abs(diffFAU)<stillThresh);
    
    %add sample start to align these indexes
    idxFAUmove = idxFAUmove + double(sampleStart);
    idxFAUstill = idxFAUstill + double(sampleStart);
    
    meanFAUmovePower = mean(meanBeta(idxFAUmove));
    meanFAUstillPower = mean(meanBeta(idxFAUstill));
    allMovePower(i) = meanFAUmovePower;
    allStillPower(i) = meanFAUstillPower;
end

figure;
plot(allMovePower,'r');
hold on;
plot(allStillPower);