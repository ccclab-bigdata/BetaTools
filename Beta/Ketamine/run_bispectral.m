dataDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Raw\Spider Man\2014-11-25\Morning';
saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Beta\Ketamine\figures';
NSxFiles = dir(fullfile(dataDir,'*.ns5'));

Fs = 3e4; % Sampling frequency
T = 1/Fs; % Sample time
L = 20*3e4; % Length of signal
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

fStart = 13;
fEnd = 30;
[~,fIdx]=find(f>=fStart & f<=fEnd);
fIdx = downsample(fIdx,10);

thresh = 2e4;
chopSamples = L; %Xs @ 30kS/s

% videoFile=fullfile(saveDir,'bicoherence10-80_morning_5sPieces.avi');
% newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
% newVideo.Quality = 100;
% newVideo.FrameRate = 20;
% open(newVideo);

for fileIdx=1:length(NSxFiles)
    disp(NSxFiles(fileIdx).name);
    %NSx = openNSx(fullfile(dataDir,NSxFiles(fileIdx).name),'read');
    pieces = findCleanSpans(NSx.Data,thresh,chopSamples);
    disp(['pieces:',num2str(length(pieces))]);

    % bispectrum = B(f1,f2)=X(f1)*X(f2)*conj(f1+f2)
    % uses indexes in such a way that f(1)*f(2) and f(2)*f(1) are excluded
    % *zero mean epochs? (p.396)
    B = [];
    RTP = [];
    BIC = [];
    meanB = [];
    channel = 5;
    
    for f1i=1:length(fIdx)
        curf1Idx = fIdx(f1i);
        for f2i=f1i:length(fIdx)
            curf2Idx = fIdx(f2i);
            epochBsum = 0;
            absEpochBsum = 0;
            for curPiece=1:size(pieces,1)
                dataM1 = NSx.Data(channel,pieces(curPiece,1):pieces(curPiece,2));
                dataM1 = dataM1-mean(dataM1(:)); %zero mean
                Y = fft(double(dataM1),NFFT)/L;
                TP = Y(curf1Idx)*Y(curf2Idx)*conj(Y(curf1Idx)+Y(curf2Idx));
                epochBsum = epochBsum+TP;
                absEpochBsum = absEpochBsum+abs(epochBsum);
            end
            B(f1i,f2i) = abs(epochBsum);
            BIC(f1i,f2i) = (B(f1i,f2i)/absEpochBsum)*100;
        end
    end
    
    
    for curPiece=1:size(pieces,1)
        dataM1 = NSx.Data(channel,pieces(curPiece,1):pieces(curPiece,2));
        dataM1 = dataM1-mean(dataM1(:)); %zero mean
        Y = fft(double(dataM1),NFFT)/L;
        %Yp = 2*abs(Y(1:NFFT/2+1));
        for f1i=1:length(fIdx)
            curf1Idx = fIdx(f1i);
            for f2i=f1i:length(fIdx)
                disp([num2str(f1i),',',num2str(f2i)]);
                curf2Idx = fIdx(f2i);
                % bispectrum
                B(f1i,f2i) = abs(Y(curf1Idx)*Y(curf2Idx)*conj(Y(curf1Idx)+Y(curf2Idx)));
                % real triple product
                RTP(f1i,f2i) = abs(Y(curf1Idx)).^2*abs(Y(curf2Idx).^2)*abs((Y(curf1Idx)+Y(curf2Idx))).^2;
                %RTP(f1i,f2i) = real(Y(curf1Idx))*real(Y(curf2Idx))*(real(Y(curf1Idx))+real(Y(curf2Idx)));
                % bicoherence
                BIC(f1i,f2i) = 100*(B(f1i,f2i)/sqrt(RTP(f1i,f2i)));
            end
        end
        %disp(['done with piece:',num2str(curPiece)]);
        
        h=figure('position',[0 0 800 800]);
        %imagesc(f(fIdx),f(fIdx),pow2db(abs(B)));
        imagesc(f(fIdx),f(fIdx),BIC);
        colorbar;
        %caxis([0 100]);
        xlabel('f1');
        ylabel('f2');
        title(['Bicoherence, morning, ',NSxFiles(fileIdx).name,', piece:',num2str(curPiece)]);

%         frame = getframe(h);
%         writeVideo(newVideo,frame);
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
% close(newVideo);

%  for i=1:length(pieces)
%     dataM1 = NSx.Data(1:16,pieces(i,1):pieces(i,2));
%     dataS1 = NSx.Data(end-15:end,pieces(i,1):pieces(i,2));
%     break;
%  end

% params.Fs=3e4;
% params.fpass=[0 100];
% [S,f]=mtspectrumc(filtDataM1,params);
% plot_vector(S,f);