waveletFunction = 'db8';

% [C,L] = wavedec(double(data),11,waveletFunction);
% d11 = wrcoef('d',C,L,waveletFunction,11);
% 
% figure;
% subplot(2,1,1);
% plot(data);
% hold on;
% plot(d11,'r');
% 
% [t,f,Snorm]=spectogramData(data,[15 30]);
% subplot(2,1,2);
% imagesc(t,f,Snorm);

%power = (sum(d11.^2))/length(d11);

% T = wpdec(double(data),11,waveletFunction);
% rwpc = wprcoef(T,(2^11)+4); %(11,1):14.6484-29.2969
% figure;
% subplot(2,1,1);
% %plot(double(data),'k');
% hold on;
% plot(rwpc,'b','linewidth',2);
% hold on;
% plot(filtfilt(SOS,G,double(data)),'r');
% axis tight;
% 
% [t,f,Snorm]=spectogramData(data,[10 45]);
% subplot(2,1,2);
% imagesc(t,f,Snorm);
% 
% wpt=wpdec(double(sdata),6,'db8');
% [S,T,F]=wpspectrum(wpt,3e4,'plot');

Fs=3e4;
wname = 'morl'; 
scales = 1:1:length(data);
oefs = cwt(data,scales,wname,'lvlabs');

freq = scal2frq(scales,wname,1/Fs);

figure; coefsSquared = abs(coefs).^2; imagesc(coefsSquared); grid off;