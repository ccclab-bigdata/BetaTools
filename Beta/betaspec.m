% Spectrogram script

function [t,f,Snorm]=betaspec(NS_piece)
    % Set parameters
    params={};
    params.Fs=30000;          %sampling rate
    params.fpass=[13 30];   %frequencies of interest
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
    
    [S t f]=mtspecgramc(double(NS_piece),[.5 .05],params);
    S1=S';

    % Normalize spectrum for each frequency
    for k = 1:length(f)
        means1=mean(S1,2);
        Snorm(k,:)=(S1(k,:)-means1(k))./means1(k);
    end

    %imagesc(t,f,Snorm);
end

