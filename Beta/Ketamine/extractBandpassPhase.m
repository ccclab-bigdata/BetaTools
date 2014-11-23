function [phases,filtData]=extractBandpassPhase(data,filt)
    load(filt);
    phases = [];
    filtData = [];
    for i=1:size(data,1)
        filtData(i,:) = filtfilt(SOS,G,double(data(i,:)));
        hx = hilbert(filtData(i,:));
        phases(i,:) = atan2(imag(hx),real(hx));
    end
end