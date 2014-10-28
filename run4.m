%betaLoc=862392;
%betaLoc=1016074;
betaLoc=1212147;

centerSpan=5000;
%figure;
channels=96;
phaseSamples = 3000;
allPhases=NaN(channels,(phaseSamples*2)+1);
phasecMap = channelMap;
allFiltData=[];

for i=1:channels
    data = NS5.Data(i,(betaLoc-centerSpan):(betaLoc+centerSpan));
    filtData = filtfilt(SOS,G,double(data));
    hx = hilbert(filtData);
    instPhase = atan2(imag(hx),real(hx));
    %[y,x]=max(filtData());
    %hold on;
    %plot(i,instPhase(centerSpan),'o');
    allFiltData(i,:) = filtData((centerSpan-phaseSamples):(centerSpan+phaseSamples));
    allPhases(i,:) = instPhase((centerSpan-phaseSamples):(centerSpan+phaseSamples));
end

diffAllPhases=diff(allPhases')';

allPgds=[];
allSpeeds=[];
allVelocityDirs=[];
newVideo = VideoWriter('betaPhase6.avi','Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 20;
open(newVideo);

for j=1:10:length(allPhases)
    h1=figure('position',[50,50,900,900]);
    subplot(3,2,3);
    for i=1:channels
        [y,x] = find(channelMap==i);
        phasecMap(x,y) = allPhases(i,j);
        hold on;
        plot(allFiltData(i,:));
        plot(j,allFiltData(i,j),'o','color','r');
    end
    xlim([0 length(allPhases)]);
    title('Bandpass (10-45Hz)');
    
    phaseGradient=gradient(phasecMap);
    [px,py]=gradient(phasecMap);
    pgd=abs(nanmean(phaseGradient(:)))/nanmean(abs(phaseGradient(:)));
    allPgds(j)=pgd;
    
    velocityDir=-nanmean(phaseGradient(:));
    allVelocityDirs(j)=velocityDir;
    if(j-1>0)
        speed=abs(mean(diffAllPhases(:,j-1)))/nanmean(abs(phaseGradient(:)));
        allSpeeds(j)=speed;
    end
    
    subplot(3,2,1);
    surf(phasecMap);
    zlim([-pi pi]);
    caxis([-pi pi]);
    title('Phase (rad)');
    
    subplot(3,2,2);
%     surf(phasecMap);
%     view(2);
    %contourf(phasecMap,250,'linestyle','none');
    quiver([1:10],[1:10],px,py);
%     caxis([-pi pi])
%     colorbar;
    xlim([0 11]);
    ylim([0 11]);
    title('Phase (rad)');
    
    subplot(3,2,4);
    rose(allPhases(:,j));
    title('All Phases (deg)');
    
    subplot(3,2,5);
    bar(allPgds);
    xlim([1 length(allPhases)]);
    ylim([0 1]);
    title('PGD(t)');
    
    subplot(3,2,6);
    hist(allPhases(:,j),10);
    xlim([-pi pi]);
    title('All Phase (rad)');
    
    textbox=uicontrol('style','text');
    text = strcat('sample:',num2str(j),', ',sprintf('%1.0f',[j/30]),'ms,pgd:',num2str(sprintf('%1.2f',[pgd])));
    set(textbox,'String',text,'position',[0,0,200,20]);

    frame = getframe(h1);
    writeVideo(newVideo,frame);
    disp(j);
    close(h1);
end    

close(newVideo);
    