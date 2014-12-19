saveDir = 'C:\Users\Matt\Desktop\svn_repository\Students\MattGaidica\Data\Analyzed\Ketamine';

videoFile=fullfile(saveDir,'Boherence10-80_allData_2sPieces_ch3.avi');
newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 30;
open(newVideo);

ketamineFrame = 125;
for frame=1:size(B,1)
    h=figure('position',[0 0 500 500]);
    imagesc(f(fIdx),f(fIdx),squeeze(B(frame,:,:)));
    colormap(hot);
    colorbar;
    caxis([min(B(:)) max(B(:))]);
    xlabel('f1');
    ylabel('f2');
    ketamineState = 'OFF KETAMINE';
    if(frame>ketamineFrame)
        ketamineState = 'ON KETAMINE';
    end
    title(['Boherence',ketamineState]);
    
    frame = getframe(h);
    writeVideo(newVideo,frame);
    close(h)
end

close(newVideo);