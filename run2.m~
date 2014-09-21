spikePhases = [];
for i=1:length(spikes.times)
    spikePhases(i)=atan2(sin(frequency*spikes.times(i)+phase),cos(frequency*spikes.times(i)+phase));
end
% % 
plot(range,sin(frequency*range+phase))
hold on;plot(spikes.times,sin(frequency*spikes.times+phase),'o','color','red')