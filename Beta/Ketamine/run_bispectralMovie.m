saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Analyzed\Ketamine';

videoFile=fullfile(saveDir,'bispectrum10-80_morning_5sPieces_r2.avi');
newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 20;
open(newVideo);

ketamineFrame = 38;
for frame=1:size(B,1)
    h=figure('position',[0 0 800 800]);
    imagesc(f(fIdx),f(fIdx),squeeze(B(frame,:,:)));
    colormap(hot);
    colorbar;
    %caxis([min(B(:)) max(B(:))]);
    caxis([0 500]);
    xlabel('f1');
    ylabel('f2');
    ketamineState = 'OFF KETAMINE';
    if(frame>ketamineFrame)
        ketamineState = 'ON KETAMINE';
    end
    title(['Bicoherence',ketamineState]);
    
    frame = getframe(h);
    writeVideo(newVideo,frame);
    close(h)
end

close(newVideo);