% (1) http://www.plexon.com/software-downloads
% (2) under the SDKs tab download the OmniPlex and MAP Offline SDK Bundle
% (3) extract the folders and add them to your Matlab path
% *there are a ton of helper files, these are not the only useful two!

% Ex2. read a PLX file and plot 2 units
% [adfreq, n, ts, fn, ad] = plx_ad(filename, channel)
channel = 11;
[f,p] = uigetfile('.plx');
[adfreq, n, ts, fn, ad] = plx_ad(fullfile(p,f),channel);
figure;
subplot(3,1,1);
plot(ad,'k'); %continous data
% [n, ts] = plx_ts(filename, channel, unit)
[nU1,tsU1] = plx_ts(fullfile(p,f),channel,1);
[nU2,tsU2] = plx_ts(fullfile(p,f),channel,2);
% convert time stamps to samples (tsXX is in seconds)
tsU1samples = int32(tsU1*3e4);
tsU2samples = int32(tsU2*3e4);

% circle the spikes
hold on;
plot(tsU1samples,ad(tsU1samples),'o','color','b');
hold on;
plot(tsU2samples,ad(tsU2samples),'o','color','r');
title('All Spikes');

% display waveforms
subplot(3,1,2);
for i=1:length(tsU1samples)
    hold on;
    plot(ad(tsU1samples(i)-20:tsU1samples(i)+20),'b');
end
title('Waveform 1');
subplot(3,1,3);
for i=1:length(tsU2samples)
    hold on;
    plot(ad(tsU2samples(i)-20:tsU2samples(i)+20),'r');
end
title('Waveform 2');