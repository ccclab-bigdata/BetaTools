figure;
for i=1000:1100
    hold on;
    plot(NEV.Data.Spikes.Waveform(:,spikeIdxs(i)))
end