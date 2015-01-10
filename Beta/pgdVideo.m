sampleStart = 1e6;
sampleEnd = 1.5e6;
videoWindow = 2e3;
step = 50;

load('Filters/betaButterCoeff.mat');
load('utahChannelMap.mat');
channels = 96;

% meanSnorm = [];
% for i=1:6:channels %just get representative values
%     disp(i);
%     data = NS5.Data(i,sampleStart:(sampleEnd+videoWindow));
%     [t,f,Snorm] = spectogramData(data,[17 45]);
%     if(i==1)
%         meanSnorm = Snorm;
%     else
%         meanSnorm = (meanSnorm+Snorm)/2;
%     end
% end

% meanSnormUpsample = [];
% for i=1:size(meanSnorm,1)
%     meanSnormUpsample(i,:) = interp1(1:length(meanSnorm),meanSnorm(i,:),linspace(1,length(meanSnorm),length(data)));
% end
% imagesc(1:length(meanSnormUpsample),f,meanSnormUpsample)
% 
% allFiltData = [];
% allPhases = [];
% for i=1:channels
%     disp(i);
%     data = NS5.Data(i,sampleStart:(sampleEnd+videoWindow));
%     allFiltData(i,:) = filtfilt(SOS,G,double(data));
%     hx = hilbert(allFiltData(i,:));
%     allPhases(i,:) = atan2(imag(hx),real(hx));
% end
% 
% meanPhases = mean(allPhases);
% diffAllPhases = diff(meanPhases')';
% stdPhases = std(allPhases);

newVideo = VideoWriter('Data/betaRoll_1e6-1p5e6.avi','Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 30;
open(newVideo);

phasecMap = utahChannelMap;
h1=figure('position',[50,50,900,900]);
for i=1:step:(sampleEnd-sampleStart)
    allPdgs = [];
    jCount = 1;
    for j=i:i+videoWindow
        for k=1:channels
            [y,x] = find(utahChannelMap==k);
            phasecMap(x,y) = allPhases(k,j);
        end
        if(j==i+(videoWindow/2)) %current reading
            %FIG surf
            subplot(3,2,2);
            surf(phasecMap,'linestyle','none');
            zlim([-pi pi]);
            caxis([-pi pi]);
            title('Phase (rad)');
            
            %FIG contour
            subplot(3,2,4);
            contourf(phasecMap,50,'linestyle','none');
            caxis([-pi pi])
            %colormap('hot');
            colorbar;
            xlim([1 10]);
            ylim([1 10]);
            title('Phase (rad)');
        end
        phaseGradient = gradient(phasecMap);
        allPdgs(jCount) = abs(nanmean(phaseGradient(:)))/nanmean(abs(phaseGradient(:)));
        jCount = jCount + 1;
    end
    
    %FIG PGD(t)
    hs(3) = subplot(3,2,5);
    hx = graph2d.constantline((videoWindow/2),'Color','r');
    changedependvar(hx,'x');
    hold on;
    plot(allPdgs);
    ylim([0 1]);
    xlim([0 videoWindow]);
    title('PGD(t)');
    
    %FIG spectogram
    hs(1) = subplot(3,2,1);
    meanSpectograms = squeeze(mean(allSpectograms));
    imagesc(1:videoWindow,f,meanSnormUpsample(:,i:i+videoWindow));
    hx = graph2d.constantline((videoWindow/2),'Color','r');
    changedependvar(hx,'x');
    caxis([min(meanSnorm(:)) max(meanSnorm(:))])
    xlim([0 videoWindow]);
    title('Power Spectrum');
    
    %FIG beta bandpass
    hs(2) = subplot(3,2,3);
    hx = graph2d.constantline((videoWindow/2),'Color','r');
    changedependvar(hx,'x');
    for j=1:channels
        hold on;
        plot(allFiltData(j,i:i+videoWindow));
    end
    xlim([0 videoWindow]);
    ylim([round(min(allFiltData(:))) round(max(allFiltData(:)))]);
    title('Bandpass Data');
    
    %FIG rose
    subplot(3,2,6);
    rose(allPhases(:,i+videoWindow));
    title('All Phases (deg)');
    
    %FIG 

    linkaxes(hs,'x');
    currentSample = i+sampleStart;
    suptitle(strcat('Sample:',num2str(currentSample)));
    
    frame = getframe(h1);
    writeVideo(newVideo,frame);
    
    disp(currentSample)
    cla(hs(2));
    cla(hs(3));
end
close(h1);
close(newVideo);