function peaksLoc=absPeakDetection(data)
    %data = wavefilter(double(NS5.Data(1,1:1000000)),5);
    data = wavefilter(double(data),5);
    peaks = findpeaks(abs(data),400);
    peaksLoc = peaks.loc;
    % plot all the spikes as sanity check
    figure;
    for i=1:length(peaks.loc)
        hold on;
        plot(data(1,peaks.loc(i)-20:peaks.loc(i)+20));
    end
end