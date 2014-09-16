% Matt Gaidica, mgaidica@med.umich.edu
% Chestek Lab, University of Michigan
% --- release: beta ---

% returns a finger angle vector where the value is the finger angle and the
% index is the etime (the index is representative of the entire experiment
% time.
function fingerVector=makeFingerVector(z)
    fingerAngles = [];
    for i=1:length(z)
        [fingerAngles,pos] = avgFingerAngles(z(1,i));
        fingerVector(1,z(1,i).ExperimentTime) = fingerAngles;
    end
    % removes some sharp trial-by-trial artifacts
    fingerVector = medfilt1(double(fingerVector),10);
end

% makes no distinction between fingers
function [fingerAngles,pos]=avgFingerAngles(zTrial)
    % averages all unmasked (active) columns
    fingerAngles = mean(zTrial.FingerAnglesTIMRL(:,logical(zTrial.MoveMask)),2);
    % simple way to get target pos for the finger
    pos = mean(zTrial.TargetPos(:,logical(zTrial.MoveMask)));
end