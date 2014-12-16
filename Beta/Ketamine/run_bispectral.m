dataDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Raw\Spider Man\2014-11-25\Morning';
saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Beta\Ketamine\figures';
NSxFiles = dir(fullfile(dataDir,'*.ns5'));

Fs = 3e4; % Sampling frequency
T = 1/Fs; % Sample time
L = 5*3e4; % Length of signal
t = (0:L-1)*T; % Time vector
% 
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
% Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

fStart = 10;
fEnd = 80;
[~,fIdx]=find(f>=fStart & f<=fEnd);
fIdx = downsample(fIdx,20);

thresh = 1e3;
chopSamples = L; %Xs @ 30kS/s
channel = 12;

% videoFile=fullfile(saveDir,'bicoherence10-80_morning_5sPieces.avi');
% newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
% newVideo.Quality = 100;
% newVideo.FrameRate = 20;
% open(newVideo);

for fileIdx=1:length(NSxFiles)
    disp(NSxFiles(fileIdx).name);
    NSx = openNSx(fullfile(dataDir,NSxFiles(fileIdx).name),'read');
    %pieces = findCleanSpans(NSx.Data,channel,thresh,chopSamples); %NO MORE
    %CHANNEL
    disp(['pieces:',num2str(length(pieces))]);

    % bispectrum = B(f1,f2)=X(f1)*X(f2)*conj(f1+f2)
    % uses indexes in such a way that f(1)*f(2) and f(2)*f(1) are excluded
    % *zero mean epochs? (p.396)
    B = [];
    TP = [];
    BIC = [];
    
    for f1i=1:5:length(fIdx)
        curf1Idx = fIdx(f1i);
        for f2i=f1i:5:length(fIdx)
            curf2Idx = fIdx(f2i);
            sumTP = 0;
            absSumTP = 0;
            for curPiece=1:5:size(pieces,1)
                disp(['f1:',num2str(f1i),',f2:',num2str(f2i),',piece:',num2str(curPiece)]);
                dataM1 = NSx.Data(channel,pieces(curPiece,1):pieces(curPiece,2));
                dataM1 = dataM1-mean(dataM1(:)); %zero mean
                Y = fft(double(dataM1),NFFT)/L;
                TP = Y(curf1Idx)*Y(curf2Idx)*conj(Y(curf1Idx)+Y(curf2Idx));
                sumTP = sumTP+TP; %real and imaginary
                absSumTP = absSumTP+abs(sumTP);
            end
            B(f1i,f2i) = abs(sumTP);
            BIC(f1i,f2i) = (B(f1i,f2i)/absSumTP)*100;
        end
    end
    
    h=figure('position',[0 0 1200 1200]);
    imagesc(f(fIdx),f(fIdx),BIC);
    colormap(hot);
    colorbar;
    caxis([0 100]);
    xlabel('f1');
    ylabel('f2');
    title(['Bicoherence, morning-',NSxFiles(fileIdx).name,', pieces:',num2str(size(pieces,1))]);
%     saveas(h,fullfile(saveDir,['bispectrum_20141125_morning',NSxFiles(fileIdx).name,'.fig']),'fig');
%     saveas(h,fullfile(saveDir,['bispectrum_20141125_morning',NSxFiles(fileIdx).name,'.png']),'png');

%         frame = getframe(h);
%         writeVideo(newVideo,frame);
    close(h)
    
end
    
% close(newVideo);

%  for i=1:length(pieces)
%     dataM1 = NSx.Data(1:16,pieces(i,1):pieces(i,2));
%     dataS1 = NSx.Data(end-15:end,pieces(i,1):pieces(i,2));
%     break;
%  end

%     saveas(h,fullfile(saveDir,['bispectrum_20141125_morning',num2str(fileIdx),'.fig']),'fig');
%     saveas(h,fullfile(saveDir,['bispectrum_20141125_morning',num2str(fileIdx),'.png']),'png');
%     close(h);

% params.Fs=3e4;
% params.fpass=[0 100];
% [S,f]=mtspectrumc(filtDataM1,params);
% plot_vector(S,f);