% Utah data file is 601s long
channel=1;
startAt=50; %seconds
endAt=53; %seconds
fs=30000;
rawdata=NS5.Data(channel,((startAt*fs)+1):(endAt*fs));
Hd=lowpassFilt;
rawdata=filter(Hd,rawdata);
figure('position',[0 50 1100 500]);plotspec(double(rawdata));
figure('position',[0 600 1100 500]);plot(startAt+(1/fs):(1/fs):endAt,rawdata);