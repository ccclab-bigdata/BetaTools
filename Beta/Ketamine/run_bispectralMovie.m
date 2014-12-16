saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Analyzed\Ketamine';

videoFile=fullfile(saveDir,'bicoherence10-80_morning_5sPieces.avi');
newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 20;
open(newVideo);

ketamineFrame = 32;
for frame=1:size(BIC,1)
    h=figure('position',[0 0 800 800]);
    imagesc(f(fIdx),f(fIdx),squeeze(BIC(frame,:,:)));
    colormap(hot);
    colorbar;
    caxis([0 100]);
    xlabel('f1');
    ylabel('f2');
    ketamineState = 'OFF KETAMINE';
    if(frame>ketamineframe)
        ketamineState = 'ON KETAMINE';
    end
    title(['Bicoherence',ketamineState]);
    
    frame = getframe(h);
    writeVideo(newVideo,frame);
    close(h)
end

close(newVideo);