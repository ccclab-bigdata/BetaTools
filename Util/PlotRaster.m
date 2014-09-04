function PlotRaster(z,chan,trial)
% plots a simple raster
% INPUTS: zstruct, channel, trial
figure();clf;
title(sprintf('%s/Channel %d/Trial %d','z',chan,trial))
hold on
t = z(1,trial).Channel(1,chan).SpikeTimes;
t = t - min(t);
    for i=1:length(t)
        line([t(i) t(i)],[0.1 0.15])
    end
    axis([0 max(t) 0 0.3])
    xlabel('time (ms)')
end


