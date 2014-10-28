% betaData=data(780000:960000);
% [tB,fB,SnormB] = spectogramData(betaData,[17 40]);
% meanBeta = normalize(smooth(mean(SnormB)));
% plot(meanBeta)

% meanAllSpect = [];
% for i=1:96
%     [tB,fB,SnormB] = spectogramData(NS5.Data(i,780000:960000),[17 40]);
%     meanAllSpect(i,:) = smooth(mean(SnormB));
%     disp(i)
% end
% [f,p]=uigetfile
% utahMap=csvread(fullfile(p,f));
% 

dir=uigetdir;
videoFile=fullfile(dir,'meanBeta_10xTrials.avi');
newVideo = VideoWriter(videoFile,'Motion JPEG AVI');
newVideo.Quality = 100;
newVideo.FrameRate = 7;
open(newVideo);
for j=1:size(meanAllSpect,2)
    surfData = [];
    for i=1:100
        if(utahMap(i)==0)
            surfData(i) = NaN;
        else
            surfData(i) = meanAllSpect(utahMap(i),j);
        end
    end
    surfData = reshape(surfData,[10,10]);
    [xx yy] = meshgrid(linspace(1,10,100));
    surfData = interp2(surfData,xx,yy);
    
    h1=figure('position',[100 100 800 800]);
    subplot(2,2,1);
    surfc(surfData,'EdgeColor','none');
    zlim([min(min(meanAllSpect))-1 max(max(meanAllSpect))]);
    xlim([1 100]);
    ylim([1 100]);
    
    subplot(2,2,2);
    surfc(surfData,'EdgeColor','none');
    view(0,90);
    zlim([min(min(meanAllSpect))-1 max(max(meanAllSpect))]);
    xlim([1 100]);
    ylim([1 100]);
    
    subplot(2,2,3);
    surfc(surfData,'EdgeColor','none');
    view(180,0);
    zlim([min(min(meanAllSpect))-1 max(max(meanAllSpect))]);
    xlim([1 100]);
    ylim([1 100]);
    
    subplot(2,2,4);
    surfc(surfData,'EdgeColor','none');
    view(90,0);
    zlim([min(min(meanAllSpect))-1 max(max(meanAllSpect))]);
    xlim([1 100]);
    ylim([1 100]);
    
    set(gca,'nextplot','replacechildren');
    set(gcf,'Renderer','zbuffer');
    frame = getframe(h1);
    writeVideo(newVideo,frame);
    close(h1);
end
close(newVideo);