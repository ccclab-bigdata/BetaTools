% beforeDir = uigetdir;
% beforeFiles = dir(fullfile(beforeDir,'*.ns5'));
% beforeFilenames = fileList(beforeDir,beforeFiles);
% 
% afterDir = uigetdir;
% afterFiles = dir(fullfile(afterDir,'*.ns5'));
% afterFilenames = fileList(afterDir,afterFiles);
% s
% nsxFiles = [beforeFilenames afterFilenames];

thresh = 2e4;
chopSamples = 20*3e4; %Xs @ 30kS/s
saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Analyzed\Ketamine';

params.Fs=3e4;
params.fpass=[0 100];
params.tapers=[3 5];
params.trialave=1;

% videoFile=fullfile(saveDir,'20141125_allFiles_S1spectrum.avi');
% newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
% newVideo.Quality = 100;
% newVideo.FrameRate = 20;
% open(newVideo);

dataLength = 0;
% ketamineLoc = 26.5*60*3e4;
ketaminePiece = 0;
% betaBiS1 = [];
% betaBiM1 = [];
pieceCount = 1;
% SsS1 = [];
% SsM1 = [];
for fileNum=1:length(nsxFiles)
    disp(nsxFiles{fileNum});
    NSx = openNSx(nsxFiles{fileNum},'read');
    pieces = findCleanSpans(NSx.Data,thresh,chopSamples);
    for i=1:length(pieces)
%         dataM1 = NSx.Data(1:16,pieces(i,1):pieces(i,2));
%         [S,f]=mtspectrumc(double(dataM1'),params);
%         SsM1 = [SsM1 S];
%         
%         dataS1 = NSx.Data(end-15:end,pieces(i,1):pieces(i,2));
%         [S,f]=mtspectrumc(double(dataS1'),params);
%         SsS1 = [SsS1 S];
        
        if(dataLength+pieces(i,1) > ketamineLoc && ketaminePiece==0)
            ketaminePiece = pieceCount;
        end
%         h=figure;
%         if(dataLength+pieces(i,1) > ketamineLoc)
%             plot_vector(S,f,'l',[],'r');
%         else
%             plot_vector(S,f,'l',[],'b');
%         end
%         xlabel('Frequency (Hz)');
%         ylabel('Spectrum dB');
%         ylim([0 100]);
%         title(['20141125, fileNum=',num2str(fileNum),'t=',num2str((dataLength+pieces(i,1))/3e4)]);
%         frame = getframe(h);
%         writeVideo(newVideo,frame);
%         close(h);
        pieceCount = pieceCount+1;
    end
    dataLength = dataLength+length(NSx.Data);
    
end
% close(newVideo);

% p1=[];
% p2=[];
% for i=1:size(a,2) %193x 20s pieces
%     p1(i)=mean(pow2db(a(betaIdx,i)));
%     p2(i)=mean(pow2db(a(betapIdx,i)));
% end

% figure;
% plot(betaBiS1);
% hold on;
% plot(betaBiM1,'r');
hx = graph2d.constantline(ketaminePiece,'Color','k');
changedependvar(hx,'x');
% legend('S1','M1');
