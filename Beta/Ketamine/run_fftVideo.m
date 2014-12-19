Fs = 3e4; % Sampling frequency
T = 1/Fs; % Sample time
L = 2*3e4; % Length of signal
t = (0:L-1)*T; % Time vector
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2+1);

thresh = 1e4;
chopSamples = L; %Xs @ 30kS/s
% pieces = findCleanSpans(allData,thresh,chopSamples);
ketaminePiece = max(find(pieces(:,1)<ketamineSample));

saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Analyzed\Ketamine';
videoFile=fullfile(saveDir,'fft_allData_2sPieces_ch3_10-30Hz.avi');
newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
newVideo.Quality = 90;
newVideo.FrameRate = 30;
open(newVideo);

allBetaP = [];
for i=1:10:length(pieces)
    plotColor = 'k';
    if(i>ketaminePiece)
        plotColor = 'r';
    end
    Y = fft(double(allData(pieces(i,1):pieces(i,2))),NFFT)/L;
    A = 2*abs(Y(1:NFFT/2+1));

    fLow = 10;
    fHigh = 30;
    h=figure('position',[0 0 500 500]);
    plot(f,A,plotColor)
    title('Single-Sided Amplitude Spectrum of y(t)')
    xlabel('Frequency (Hz)')
    ylabel('|Y(f)|')
    xlim([fLow fHigh])
    ylim([0 300]);
    
    frame = getframe(h);
    writeVideo(newVideo,frame);
    close(h)
end

close(newVideo);