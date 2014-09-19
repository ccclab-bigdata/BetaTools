data = wavefilter(double(NS5.Data(1,1:1000000)),5);
peaks = findpeaks(abs(data),400);

figure;
for i=1:length(peaks.loc)
    hold on;
    plot(data(1,peaks.loc(i)-20:peaks.loc(i)+20));
end