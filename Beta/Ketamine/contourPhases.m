function contourPhases(phaseMap1,phaseMap2)
    saveFile = 'ketamine_run001_trialStart5_30s.avi';
    saveDir = uigetdir;
    newVideo = VideoWriter(fullfile(saveDir,saveFile),'Motion JPEG AVI');
    newVideo.Quality = 100;
    newVideo.FrameRate = 20;
    open(newVideo);
    
    h1 = figure('position',[100 100 500 700]);
    startSample = 1;
    stopSample = length(phaseMap1);
    for i=startSample:10:stopSample
        disp('Percent Complete:');
        disp(round((i/stopSample)*100))
        
        subplot(2,2,1);
        rose(reshape(phaseMap1(:,:,i),[1 16]));
        title('S1 Phase');

        subplot(2,2,2);
        rose(reshape(phaseMap2(:,:,i),[1 16]));
        title('M1 Phase');

        subplot(2,2,3);
        contourf(phaseMap1(:,:,i),'linestyle','none');
        caxis([-pi pi]);
        title('S1')
        axis vis3d
        axis square
        view(125,90)
        axis off

        subplot(2,2,4);
        contourf(phaseMap2(:,:,i),'linestyle','none');
        caxis([-pi pi]);
        title('M1')
        axis vis3d
        axis square
        view(-100,90)
        axis off
        
        colormap(gray)
        
        suptitle(num2str(i));
        
        frame = getframe(h1);
        writeVideo(newVideo,frame);
    end
    close(h1);
    close(newVideo);
end