% %zRun002, NEV1:1-141, NEV2:143-252, NEV3:254-275 LOAD NEW NS5 FOR EACH!
% zStart = 143;
% zStop = 252;
% allSampleStart = zNew(1,zStart).CerebusTimeStart;
% allSampleStop = zNew(1,zStop).CerebusTimeStop;
% meanSnorm = [];
% iCount=1;
% for i=26:28 %just get representative values
%     disp(i);
%     data = NS5.Data(i,allSampleStart:allSampleStop);
%     [t,f,Snorm] = spectogramData(data,[14 30]);
%     if(iCount==1)
%         meanSnorm = Snorm;
%     else
%         meanSnorm = (meanSnorm+Snorm)/2;
%     end
%     iCount=iCount+1;
% end
% 
% meanSnormUpsample = [];
% for i=1:size(meanSnorm,1)
%     meanSnormUpsample(i,:) = interp1(1:length(meanSnorm),meanSnorm(i,:),linspace(1,length(meanSnorm),length(data)));
% end
% meanBeta = mean(meanSnormUpsample);
% normMeanBeta = normalize(meanBeta);

saveDir = uigetdir;

moveThresh = 6e-5;
stillThresh = 1e-5;
allMovePower = [];
allStillPower = [];
iCount=1;
for i=zStart:zStop
    sampleStart = zNew(1,i).CerebusTimeStart;
    sampleStop = zNew(1,i).CerebusTimeStop;
    sampleLength = sampleStop-sampleStart;
    % these are made because the beta spectogram is based off a minimum
    % start-stop window, so meanBeta(1) correlates to the first zTrial
    % CerebrusTimeStart in that run
    shiftedStart = (allSampleStart-sampleStart)+1;
    shiftedStop = shiftedStart+sampleLength;
    disp((sampleStop-sampleStart)/3e4);
    [fingerAngles,pos]=avgFingerAngles(zNew(1,i));
    %fingerAnglesDigital = round(fingerAngles);
    fingerAnglesUpsample = interp1(1:length(fingerAngles),fingerAngles(:),linspace(1,length(fingerAngles),sampleStop-sampleStart));
    diffFAU = diff(smooth(fingerAnglesUpsample,500));
    idxFAUmove = find(abs(diffFAU)>=moveThresh);
    idxFAUstill = find(abs(diffFAU)<moveThresh);   
    
    if(~isempty(idxFAUmove) && ~isempty(idxFAUstill))
        betaWindowSpect = meanSnormUpsample(:,shiftedStart:shiftedStop);
        betaWindowPower = normMeanBeta(shiftedStart:shiftedStop);
        meanFAUmovePower = mean(betaWindowPower(idxFAUmove));
        meanFAUstillPower = mean(betaWindowPower(idxFAUstill));
        allMovePower(iCount) = meanFAUmovePower;
        allStillPower(iCount) = meanFAUstillPower;
        iCount=iCount+1;
    else
        break;
    end
    
    if(false)
        h1=figure('position',[0 0 700 900]);
        subplot(4,1,1);
        plot(fingerAnglesUpsample);
        xlim([1 length(fingerAnglesUpsample)]);
        title('Finger Angle');
        subplot(4,1,2);
        plot(abs(diffFAU));
        hold on;
        line([1 length(fingerAnglesUpsample)],[moveThresh moveThresh],'color','r');
        xlim([1 length(fingerAnglesUpsample)]);
        title('Abs Diff Finger Angle');
        subplot(4,1,3);
        imagesc(length(betaWindowSpect),f,betaWindowSpect);
        hold on;
        caxis([min(betaWindowSpect(:)) max(betaWindowSpect(:))]);
        title('Beta Power Spectrum');
        subplot(4,1,4);
        plot(idxFAUstill,betaWindowPower(idxFAUstill),'o','color','k');
        hold on;
        plot(idxFAUmove,betaWindowPower(idxFAUmove),'o','color','r')
        xlim([1 length(fingerAnglesUpsample)]);
        legend('Not Moving','Moving');
        ylabel('Norm Power');
        title('Beta Power Assignment');
        subplot(4,1,1);
        suptitle(strcat('Samples:',num2str(sampleStart),'-',num2str(sampleStop)));
        
        saveas(h1,fullfile(saveDir,strcat('run002_samples_',num2str(sampleStart),'-',num2str(sampleStop),'.fig')),'fig');
        saveas(h1,fullfile(saveDir,strcat('run002_samples_',num2str(sampleStart),'-',num2str(sampleStop),'.jpg')),'jpg');
    end
    
end

figure('position',[0 0 700 500]);
subplot(2,1,1);
plot(allMovePower,'r');
xlim([1 length(allMovePower)]);
mamp = mean(allMovePower(~isnan(allMovePower(:))));
line([1 length(allMovePower)],[mamp mamp],'color','r');
hold on;
plot(allStillPower);
masp = mean(allStillPower); %could remove NaN if its an issue
line([1 length(allStillPower)],[mean(allStillPower) mean(allStillPower)]);
xlabel('Trial')
ylabel('Relative Power')
legend('Moving','mean','Not Moving','mean');
title('Trials');
subplot(2,1,2);
imagesc(t,f,Snorm);
ylabel('Frequency (Hz)')
title('Beta Power Spectrum');

movementCount = 0;
validTrials = 0;
meanAllPowers = mean([mamp masp]);
for i=1:length(allStillPower)
    if(~isnan(allStillPower(i)) && ~isnan(allMovePower(i)))
        if(abs(meanAllPowers-allStillPower(i))<abs(meanAllPowers-allMovePower(i)))
            movementCount=movementCount+1;
        end
        validTrials = validTrials+1;
    end
end
disp('movement trials / all trials');
disp(movementCount/validTrials);
disp('Std Movement');
disp(std(allMovePower));
disp('Std Non-movement');
disp(std(allStillPower));

% %zRun002, NEV1:1-141, NEV2:143-252, NEV3:254-275
% str='';
% for i=1:length(zNew)
%     curNev = zNew(1,i).NEVFile;
%     if(~strcmp(curNev,str))
% 
%         disp(i)
%         str=curNev;
%     end
% end

beep
