% should have allData and pieces variables formed
Fs = 3e4; % Sampling frequency
T = 1/Fs; % Sample time
L = 2*3e4; % Length of signal
t = (0:L-1)*T; % Time vector
% 
NFFT = 2^nextpow2(L); % Next power of 2 from length of y
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
% plot(f,2*abs(Y(1:NFFT/2+1))) 
% title('Single-Sided Amplitude Spectrum of y(t)')
% xlabel('Frequency (Hz)')
% ylabel('|Y(f)|')

fStart = 10;
fEnd = 80;
[~,fIdx]=find(f>=fStart & f<=fEnd);
%fIdx = downsample(fIdx,2);

ketamineSample = (26*60+30)*3e4; %@26:30 into recording
jStep = 5;
B = zeros(length(1:jStep:length(pieces)),length(fIdx),length(fIdx));
BIC = B;
frame = 1;

for f1i=1:length(fIdx)
    curf1Idx = fIdx(f1i);
    for f2i=f1i:length(fIdx)
        curf2Idx = fIdx(f2i);
        frame = 1;
        for startPiece=1:jStep:length(pieces)-jStep %don't overrun pieces
            sumTP = 0;
            absSumTP = 0;
            for curPiece=startPiece:startPiece+jStep-1 %multiple epochs
                disp(['f1:',num2str(f1i),',f2:',num2str(f2i),',piece:',num2str(curPiece)...
                    ',frame:',num2str(frame)]);
                dataM1 = allData(pieces(curPiece,1):pieces(curPiece,2));
                dataM1 = dataM1-mean(dataM1(:)); %zero mean
                Y = fft(double(dataM1),NFFT)/L;

                TP = Y(curf1Idx)*Y(curf2Idx)*conj(Y(curf1Idx)+Y(curf2Idx));
                sumTP = sumTP+TP; %real and imaginary
                absSumTP = absSumTP+abs(sumTP);
            end
            B(frame,f1i,f2i) = abs(sumTP);
            BIC(frame,f1i,f2i) = (B(frame,f1i,f2i)/absSumTP)*100;
            frame = frame+1;
        end
    end
end