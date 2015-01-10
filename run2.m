%zRun002, NEV1:1-141, NEV2:143-252, NEV3:254-275 LOAD NEW NS5 FOR EACH!
zStart = 143;
zStop = 252;
allSampleStart = zNew(1,zStart).CerebusTimeStart;
allSampleStop = zNew(1,zStop).CerebusTimeStop;
longTrial = 3e4*3;
trialCount = 1;
followerFlag = false;
longTrialPower = [];
followerTrialPower = [];
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
    if(sampleLength>longTrial && ~followerFlag)
        followerFlag = true;
        longTrialPower(trialCount) = mean(normMeanBeta(shiftedStart:shiftedStop));
    end
    if(followerFlag)
        followerFlag = false;
        trialCount = trialCount+1;
        shortTrialPower(trialCount) = mean(normMeanBeta(shiftedStart:shiftedStop));
    end
end

disp(trialCount)
bar([mean(longTrialPower) mean(shortTrialPower)]);