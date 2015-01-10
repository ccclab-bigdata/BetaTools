function [fingerAngles,pos]=avgFingerAngles(zTrial)
    % averages all unmasked (active) columns
    fingerAngles = mean(zTrial.FingerAnglesTIMRL(:,logical(zTrial.MoveMask)),2);
    % simple way to get target pos for the finger
    pos = mean(zTrial.TargetPos(:,logical(zTrial.MoveMask)));
end