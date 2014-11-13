function phases=extractBandpassPhase(data)
    load('10-45Hz_butter_30kHz.mat');
    phases = [];
    for i=1:length(data)
        filtData(i,:) = filtfilt(SOS,G,double(data));
        hx = hilbert(filtData(i,:));
        phases(i,:) = atan2(imag(hx),real(hx));
    end
end