dataDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Raw\Spider Man\2014-11-25\Morning';
saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Beta\Ketamine\figures';
NSxFiles = dir(fullfile(dataDir,'*.ns5'));

Fs = 3e4; % Sampling frequency
T = 1/Fs; % Sample time
L = 10*3e4; % Length of signal
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
fEnd = 100;
[~,fIdx]=find(f>=fStart & f<=fEnd);

thresh = 2e4;
chopSamples = L; %Xs @ 30kS/s

videoFile=fullfile(saveDir,'bispectrum_morning_10sPieces.avi');
newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 30;
open(newVideo);

for fileIdx=1:length(NSxFiles)
    disp(NSxFiles(fileIdx).name);
    NSx = openNSx(fullfile(dataDir,NSxFiles(fileIdx).name),'read');
    pieces = findCleanSpans(NSx.Data,thresh,chopSamples);
    disp(['pieces:',num2str(length(pieces))]);

    % bispectrum = B(f1,f2)=X(f1)*X(f2)*conj(f1+f2)
    % uses indexes in such a way that f(1)*f(2) and f(2)*f(1) are excluded
    % *zero mean epochs? (p.396)
    B = [];
    meanB = [];
    channel = 5;
    for curPiece=1:length(pieces)
        dataM1 = NSx.Data(channel,pieces(curPiece,1):pieces(curPiece,2));
        Y = fft(double(dataM1),NFFT)/L;
        for f1i=1:length(fIdx)
            curf1Idx = fIdx(f1i);
            for f2i=f1i:length(fIdx)
                curf2Idx = fIdx(f2i);
                B(f1i,f2i) = Y(curf1Idx)*Y(curf2Idx)*conj(Y(curf1Idx)+Y(curf2Idx));
            end
        end
        
        h=figure('position',[0 0 800 800]);
        imagesc(f(fIdx),f(fIdx),pow2db(abs(meanB)));
        colorbar;
        caxis([-20 60]);
        xlabel('f1');
        ylabel('f2');
        title(['Bispectrum in dB - morning_',NSxFiles(fileIdx).name,'_piece:',num2str(curPiece)]);
        
        frame = getframe(h);
        writeVideo(newVideo,frame);
        close(h)

%         if(curPiece==1)
%             meanB = B;
%         else
%             meanB = (meanB+B)/2;
%         end
    end

    
    
%     saveas(h,fullfile(saveDir,['bispectrum_20141125_morning',num2str(fileIdx),'.fig']),'fig');
%     saveas(h,fullfile(saveDir,['bispectrum_20141125_morning',num2str(fileIdx),'.png']),'png');
%     close(h);
end
close(newVideo);

%  for i=1:length(pieces)
%     dataM1 = NSx.Data(1:16,pieces(i,1):pieces(i,2));
%     dataS1 = NSx.Data(end-15:end,pieces(i,1):pieces(i,2));
%     break;
%  end