data = wavefilter(double(NS5.Data(1,1:100000)),5);
peaksLoc = absPeakDetection(data);
figure;hold on;
plot(data);
% plot(abs(data),'r');

for i=1:length(peaksLoc)
    plot(peaksLoc(i),data(1,peaksLoc(i)),'o');
end