%zRun002, NEV1:1-141, NEV2:143-252, NEV3:254-275 LOAD NEW NS5 FOR EACH!
zStart = 143;
zStop = 252;
allSampleStart = zNew(1,zStart).CerebusTimeStart;
allSampleStop = zNew(1,zStop).CerebusTimeStop;
moveThresh = 6e-5;
validTrialCount = 1;
sampleWindow = 3e4/4;
powerBefore=[];
powerDuring=[];
powerAfter=[];
for i=zStart:zStop
%     disp(i)
    % these are made because the beta spectogram is based off a minimum
    % start-stop window, so normMeanBeta(1) correlates to the first zTrial
    % CerebrusTimeStart in that run
    sampleStart = zNew(1,i).CerebusTimeStart;
    sampleStop = zNew(1,i).CerebusTimeStop;
    sampleLength = sampleStop-sampleStart;
    shiftedStart = (allSampleStart-sampleStart)+1;
    shiftedStop = shiftedStart+sampleLength;
%     disp((sampleStop-sampleStart)/3e4);
    [fingerAngles,pos]=avgFingerAngles(zNew(1,i));
    fingerAnglesUpsample = interp1(1:length(fingerAngles),fingerAngles(:),linspace(1,length(fingerAngles),sampleStop-sampleStart));
    diffFAU = diff(smooth(fingerAnglesUpsample,500));
    [v,k] = max(diffFAU);
    if(v>moveThresh && (k+2*sampleWindow)<length(fingerAnglesUpsample) && (k-2*sampleWindow)>0)
        center = k+shiftedStart;
        spanBefore = (center-2*sampleWindow):center;
        spanDuring = (center-sampleWindow):(center+sampleWindow);
        spanAfter = center:(center+2*sampleWindow);
        powerBefore(validTrialCount) = mean(normMeanBeta(spanBefore));
        powerDuring(validTrialCount) = mean(normMeanBeta(spanDuring));
        powerAfter(validTrialCount) = mean(normMeanBeta(spanAfter));
        validTrialCount = validTrialCount+1;
    end
end

disp(validTrialCount)
bar([mean(powerBefore) mean(powerDuring) mean(powerAfter)]);