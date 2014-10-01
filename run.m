saveDir = uigetdir;
for i=2:2
    run_betaGammaFingerPower(NS5,NEV,z,i);
    for j=1:2
        h=figure(j);
        set(h,'Units','Inches');
        pos = get(h,'Position');
        set(h,'PaperPositionMode','Auto','PaperUnits','Inches','PaperSize',[pos(3), pos(4)])
        filename = strcat('channel',num2str(i,'%03i'),'_figure',num2str(j),'.pdf');
        print(h,'-dpdf',fullfile(saveDir,filename));
    end
    close all;
end