% beforeDir = uigetdir;
% beforeFiles = dir(fullfile(beforeDir,'*.ns5'));
% beforeFilenames = fileList(beforeDir,beforeFiles);
% 
% afterDir = uigetdir;
% afterFiles = dir(fullfile(afterDir,'*.ns5'));
% afterFilenames = fileList(afterDir,afterFiles);
% 
% nsxFiles = [beforeFilenames afterFilenames];

thresh = 2e4;
chopSamples = 5*3e4; %5s @ 30kS/s
usefilter = '13-30Hz_butter_30kHz.mat';
saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Beta\Ketamine\figures';

for fileNum=1:length(nsxFiles)
    NSx = openNSx(nsxFiles{fileNum},'read');
    pieces=findCleanSpans(NSx.Data,thresh,chopSamples);
%     allData = [];
    hbar = waitbar(0,'processing pieces...');

    for i=1:length(pieces)
        waitbar(i/length(pieces),hbar);
        dataM1=NSx.Data(1:16,pieces(i,1):pieces(i,2));
        dataS1=NSx.Data(end-15:end,pieces(i,1):pieces(i,2));
        [phasesS1,filtDataS1] = extractBandpassPhase(dataS1,usefilter);
        [phasesM1,filtDataM1] = extractBandpassPhase(dataM1,usefilter);

        data = zeros(16);
        for s1i=1:16
            for m1i=1:16
                [r,p] = corrcoef(phasesS1(s1i,:),phasesM1(m1i,:));
                data(s1i,m1i) = r(1,2);
            end
        end
    %     allData(i,:,:) = data;
    end
    close(hbar)

    v = genvarname(['allData_',num2str(fileNum)],who);
    eval([v ' = data;']);
    
    h=figure;
    imagesc(data);
    colorbar;
    colormap(gray);
    caxis([min(data(:)) max(data(:))]);
    xlabel('M1');
    ylabel('S1');
    titleStr = ['20141125-betaCorr-',num2str(fileNum)];
    title(titleStr);
    
    saveas(h,fullfile(saveDir,[titleStr,'.fig']),'fig');
    saveas(h,fullfile(saveDir,[titleStr,'.png']),'png');
    close(h);
end