function zTrialStarts=getZTrialStarts(z)
    zTrialStarts = [];
    for i=1:length(z)
        zTrialStarts(i) = z(1,i).ExperimentTime(1,1);
    end
end