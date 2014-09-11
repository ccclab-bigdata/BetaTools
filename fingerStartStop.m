function [start,stop]=fingerStartStop(fingerAngles)
    allEvents = diff(mean(fingerAngles,2));
    [minv,mink] = min(allEvents);
    [maxv,maxk] = max(allEvents);
    
    plot(allEvents);
end