params.Fs=3e4;
params.fpass=[10 40];
params.tapers=[10 19];
params.err=[1 0.05];

data = double(NS5.Data(1,1:1000000));
HPdata = wavefilter(data,5);
peaks = findpeaks(abs(HPdata),400);
[C,phi,S12,S1,S2,f,zerosp,confC,phistd] = coherencycpt(data',peaks.loc*(params.Fs^-1),params);
figure;
plot(f,C);
figure;
plot(S2);