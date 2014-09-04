function plotspec(NS_piece)
% Spectrogram script; Karen
% 
% This code uses m files from the Chronux toolbox
% Please add the folder to your path! 

clear k S S1 Snorm f means1 params t %NS_piece
clf

% Set parameters
params={};
params.Fs=3e4;          %sampling rate
params.fpass=[0 100];   %frequencies of interest
params.err=0;           %error calculation [1 p] - Theoretical error bars; [2 p] - Jackknife error bars
                                   %[0 p] or 0 - no error bars) - optional. Default 0.
params.trialave=0;      %average over trials? Default 0.
params.tapers=[5 9];    %optional! see mtspecgramc for details
params.pad=1;           %padding factor for the FFT - optional (can take values -1,0,1,2...). 
%                    -1 corresponds to no padding, 0 corresponds to padding
%                    to the next highest power of 2 etc.
%			      	 e.g. For N = 500, if PAD = -1, we do not pad; if PAD = 0, we pad the FFT
%			      	 to 512 points, if pad=1, we pad to 1024 points etc.
%			      	 Defaults to 0.

% compute spectrum
% Output:
%       S       (spectrum in form time x frequency x channels/trials if trialave=0; 
%               in the form time x frequency if trialave=1)
%       t       (times)
%       f       (frequencies)
%       Serr    (error bars) only for err(1)>=1
[S t f]=mtspecgramc(NS_piece,[.5 .05],params);
S1=S';

% Normalize spectrum for each frequency
for k = 1:length(f)
    means1=mean(S1,2);
    Snorm(k,:)=(S1(k,:)-means1(k))./means1(k);
end

%plot
imagesc(t,f,Snorm); 


