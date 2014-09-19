function peaksLoc=absPeakDetection(data)
    %data = wavefilter(double(NS5.Data(1,1:1000000)),5);
    data = wavefilter(double(data),5);
    peaks = findpeaks(abs(data),400);
    peaksLoc = peaks.loc;
    
    temp = [];
    count = 1;
    window = 50;
    for i=2:length(peaksLoc)-1
        if(peaksLoc(i+1)-peaksLoc(i) < 60)
            if(abs(data(1,peaksLoc(i+1))) > abs(data(1,peaksLoc(i))))
                continue;
            end
        end
        temp(count) = peaksLoc(i);
        count = count + 1;
    end
    peaksLoc = temp;
    % plot all the spikes as sanity check
    figure;
    for i=1:length(peaksLoc)
        hold on;
        plot(data(1,peaksLoc(i)-20:peaksLoc(i)+20));
    end
end